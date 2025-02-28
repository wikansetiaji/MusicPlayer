//
//  TracksVM.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation
import Combine

protocol TracksVMProtocol: ObservableObject {
  var tracks: [Track] { get set }
  var offset: Int { get set }
  var query: String { get set }
  var isLoading: Bool { get set }
  var isLoadingNextPage: Bool { get }
  var error: APIError? { get set }
  var totalCount: Int { get }
  var canLoadMore: Bool { get }
  init(repository: MusicRepositoryProtocol)
  func getTracks()
  func loadNextPage()
}

class TracksVM: TracksVMProtocol {
  @Published var tracks: [Track] = []
  @Published var isLoading: Bool = false
  @Published var isLoadingNextPage: Bool = false
  @Published var offset: Int = 0
  @Published var query: String = ""
  @Published var error: APIError?
  
  var totalCount: Int = 0
  var canLoadMore: Bool {
    self.tracks.count < self.totalCount
  }
  
  private var cancellables: Set<AnyCancellable> = []
  private let repository: MusicRepositoryProtocol
  
  required init(repository: MusicRepositoryProtocol) {
    self.repository = repository
    self.setupSubscribings()
  }
  
  func getTracks() {
    if self.offset > 0 {
      self.isLoadingNextPage = true
    } else {
      self.isLoading = true
    }
    self.repository.getTracks(query: self.query, offset: self.tracks.count)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        switch value {
        case .failure(let error):
          self?.isLoading = false
          self?.isLoadingNextPage = false
          self?.error = error
          self?.tracks = []
        case .finished:
          break
        }
      } receiveValue: { [weak self] tracksResponse in
        self?.isLoading = false
        self?.isLoadingNextPage = false
        if self?.offset == 0 {
          self?.tracks = tracksResponse.results
        } else {
          self?.tracks.append(contentsOf: tracksResponse.results)
        }
        self?.totalCount = tracksResponse.headers.totalCount
      }
      .store(in: &cancellables)
  }
  
  func loadNextPage() {
    self.offset = self.tracks.count
  }
  
  private func setupSubscribings() {
    self.$query
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // Adjust the delay as needed
      .sink { [weak self] _ in
        self?.offset = 0
      }
      .store(in: &cancellables)
    
    self.$offset
      .sink { [weak self] _ in
        self?.getTracks()
      }
      .store(in: &cancellables)
  }
}

//
//  TracksVM.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation
import Combine
import AVKit

protocol TracksVMProtocol: ObservableObject {
  var tracks: [Track] { get set }
  var query: String { get set }
  var isLoading: Bool { get set }
  var isLoadingNextPage: Bool { get }
  var error: APIError? { get set }
  var canLoadMore: Bool { get }
  
  init(repository: MusicRepositoryProtocol)
  
  func getTracks()
  func loadNextPage()
}

class TracksVM: TracksVMProtocol {
  @Published var tracks: [Track] = []
  @Published var query: String = ""
  @Published var isLoading: Bool = false
  @Published var isLoadingNextPage: Bool = false
  @Published var offset: Int = 0
  @Published var error: APIError?
  
  var totalCount: Int = 0
  var canLoadMore: Bool {
    self.tracks.count < self.totalCount && !self.isLoading
  }
  
  private var cancellables: Set<AnyCancellable> = []
  private let repository: MusicRepositoryProtocol
  
  required init(repository: MusicRepositoryProtocol) {
    self.repository = repository
    self.setupSubscribings()
  }
  
  private func setupSubscribings() {
    self.$query
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.tracks = []
        self?.offset = 0
      }
      .store(in: &cancellables)
    
    self.$offset
      .sink { [weak self] _ in
        self?.getTracks()
      }
      .store(in: &cancellables)
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
          self?.error = nil
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
}

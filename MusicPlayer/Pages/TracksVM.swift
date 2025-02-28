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
  var currentPage: Int { get set }
  var query: String { get set }
  var isLoading: Bool { get set }
  var isLoadingNextPage: Bool { get set }
  var error: APIError? { get set }
  init(repository: MusicRepositoryProtocol)
  func getTracks()
  func loadNextPage()
}

class TracksVM: TracksVMProtocol {
  @Published var tracks: [Track] = []
  @Published var isLoading: Bool = false
  @Published var isLoadingNextPage: Bool = false
  @Published var currentPage: Int = 0
  @Published var query: String = ""
  @Published var error: APIError?
  private var cancellables: Set<AnyCancellable> = []
  private let repository: MusicRepositoryProtocol
  
  required init(repository: MusicRepositoryProtocol) {
    self.repository = repository
    self.setupSubscribings()
  }
  
  func getTracks() {
    if self.currentPage > 0 {
      self.isLoadingNextPage = true
    } else {
      self.isLoading = true
    }
    self.repository.getTracks(query: self.query, page: self.currentPage)
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
        self?.tracks = tracksResponse.results
      }
      .store(in: &cancellables)
  }
  
  func loadNextPage() {
    self.currentPage += 1
  }
  
  private func setupSubscribings() {
    self.$query
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // Adjust the delay as needed
      .sink { [weak self] _ in
        self?.currentPage = 0
      }
      .store(in: &cancellables)
    
    self.$currentPage
      .sink { [weak self] _ in
        self?.getTracks()
      }
      .store(in: &cancellables)
  }
}

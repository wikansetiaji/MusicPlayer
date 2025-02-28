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
  func getTracks(query: String, page: Int)
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
  }
  
  func getTracks(query: String, page: Int) {
    self.currentPage = page
    self.query = query
    if page > 0 {
      self.isLoadingNextPage = true
    } else {
      self.isLoading = true
    }
    self.repository.getTracks(query: query, page: page)
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
    self.getTracks(query: self.query, page: self.currentPage)
  }
}

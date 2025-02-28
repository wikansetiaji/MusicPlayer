//
//  MusicRepository.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation
import Combine

protocol MusicRepositoryProtocol: Repository {
  func getTracks(query: String, page: Int) -> AnyPublisher<TracksResponse, APIError>
}

class MusicRepository: MusicRepositoryProtocol {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func getTracks(query: String, page: Int) -> AnyPublisher<TracksResponse, APIError> {
    return fetch(with: self.tracksURLComponent(query: query), session: self.session)
  }
  
  private func tracksURLComponent(query: String) -> URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.jamendo.com"
    components.path = "/v3.0/tracks/"
    components.queryItems = [
      URLQueryItem(name: "client_id", value: "8f2e21c5"),
      URLQueryItem(name: "format", value: "jsonpretty"),
      URLQueryItem(name: "limit", value: "10"),
      URLQueryItem(name: "search", value: query),
    ]
    return components
  }
}

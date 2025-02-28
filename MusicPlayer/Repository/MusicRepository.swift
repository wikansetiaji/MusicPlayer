//
//  MusicRepository.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation
import Combine

protocol MusicRepositoryProtocol: Repository {
  func getTracks(query: String, offset: Int) -> AnyPublisher<TracksResponse, APIError>
}

class MusicRepository: MusicRepositoryProtocol {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func getTracks(query: String, offset: Int) -> AnyPublisher<TracksResponse, APIError> {
    print("FETCH TRACKS - offset: \(offset), query: \(query)")
    return fetch(with: self.tracksURLComponent(query: query, offset: offset), session: self.session)
  }
  
  private func tracksURLComponent(query: String, offset: Int) -> URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.jamendo.com"
    components.path = "/v3.0/tracks"
    components.queryItems = [
      URLQueryItem(name: "client_id", value: "8f2e21c5"),
      URLQueryItem(name: "format", value: "jsonpretty"),
      URLQueryItem(name: "limit", value: "20"),
      URLQueryItem(name: "search", value: query),
      URLQueryItem(name: "order", value: "popularity_total"),
      URLQueryItem(name: "fullcount", value: "true"),
      URLQueryItem(name: "offset", value: "\(offset)"),
    ]
    return components
  }
}

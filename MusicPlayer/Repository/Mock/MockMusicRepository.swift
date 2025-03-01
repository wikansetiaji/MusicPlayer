//
//  MockMusicRepository.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 01/03/25.
//

import Foundation
import Combine

class MockMusicRepository: MusicRepositoryProtocol {
  var getTracksResult: Result<TracksResponse, APIError> = .failure(.network(message: "mock"))
  
  func getTracks(query: String, offset: Int) -> AnyPublisher<TracksResponse, APIError> {
    return Future { promise in
      promise(self.getTracksResult)
    }
    .eraseToAnyPublisher()
  }
}

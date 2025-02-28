//
//  TracksResponse.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation

struct TracksResponse: Codable {
  var results: [Track]
  var headers: TracksHeader
}

struct TracksHeader: Codable {
  var count: Int
  var totalCount: Int
  
  enum CodingKeys: String, CodingKey {
    case count = "results_count"
    case totalCount = "results_fullcount"
  }
}

//
//  Track.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation

struct Track: Codable, Identifiable {
  var id: String
  var name: String
  var duration: Int
  var artistName: String
  var albumName: String
  var image: String
  var audio: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case duration
    case artistName = "artist_name"
    case albumName = "album_name"
    case image
    case audio
  }
}

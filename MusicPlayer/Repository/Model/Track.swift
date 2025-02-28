//
//  Track.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation

struct Track: Codable, Identifiable, Equatable {
  var id: String
  var name: String
  var duration: Int
  var artistName: String
  var albumName: String
  var albumId: String
  var audio: String
  var image: String {
    "https://usercontent.jamendo.com?type=album&id=\(albumId)&width=50&trackid=\(id)"
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case duration
    case artistName = "artist_name"
    case albumName = "album_name"
    case albumId = "album_id"
    case audio
  }
}

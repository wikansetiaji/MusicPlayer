//
//  Error.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

enum APIError: Error {
  case request(message: String)
  case network(message: String)
  case status(message: String)
  case parsing(message: String)
  case other(message: String)
  
  static func map(_ error: Error) -> APIError {
    return (error as? APIError) ?? .other(message: error.localizedDescription)
  }
  
}

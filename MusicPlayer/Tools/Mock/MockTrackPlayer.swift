//
//  MockTrackPlayer.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 01/03/25.
//

import Foundation
import AVKit

class MockTrackPlayer: TrackPlayerProtocol {
  var currentTime: Double = 0
  var isPlaying: Bool = false
  var currentTrack: Track?
  
  func selectTrack(track: Track, tracks: [Track]) { }
  func addToPlayNext(track: Track) { }
  func playPauseTrack() { }
  func nextTrack() { }
  func previousTrack() { }
  func seek(to time: CMTime) { }
}

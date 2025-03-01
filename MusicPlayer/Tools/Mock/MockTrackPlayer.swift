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
  var currentTrack: Track? = Track(
    id: "1532771",
    name: "Track 4",
    duration: 64,
    artistName: "Artist",
    albumName: "Album",
    albumId: "404140",
    audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
  )
  
  func selectTrack(track: Track, tracks: [Track]) { }
  func addToPlayNext(track: Track) { }
  func playPauseTrack() { }
  func nextTrack() { }
  func previousTrack() { }
  func seek(to time: CMTime) { }
}

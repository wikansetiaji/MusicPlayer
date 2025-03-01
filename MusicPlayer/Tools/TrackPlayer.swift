//
//  TrackPlayer.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 01/03/25.
//

import Foundation
import Combine
import AVKit

protocol TrackPlayerProtocol: ObservableObject {
  var currentTime: Double { get set }
  var isPlaying: Bool { get set }
  var currentTrack: Track? { get set }
  
  func selectTrack(track: Track, tracks: [Track])
  func addToPlayNext(track: Track)
  func playPauseTrack()
  func nextTrack()
  func previousTrack()
  func seek(to time: CMTime)
}

class TrackPlayer: TrackPlayerProtocol {
  @Published var currentTime: Double = 0
  @Published var isPlaying: Bool = false
  @Published var currentTrack: Track?
  
  var player: AVPlayer?
  var trackQueue: [Track] = []
  var currentTrackIndex: Int = 0
  
  var isHaveNextTrack: Bool {
    return self.currentTrackIndex + 1 < self.trackQueue.count
  }
  
  var isHavePreviousTrack: Bool {
    return self.currentTrackIndex - 1 >= 0
  }
  
  private var cancellables: Set<AnyCancellable> = []
  
  static let shared: TrackPlayer = TrackPlayer()
  
  private init() {
    self.setupSubscribings()
  }
  
  private func setupSubscribings() {
    self.$currentTrack
      .sink { [weak self] track in
        if let audio = track?.audio, let url = URL(string: audio) {
          self?.player = AVPlayer(url: url)
          self?.playPauseTrack()
        }
      }
      .store(in: &cancellables)
    
    Timer.publish(every: 1, on: .main, in: .default)
      .autoconnect()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
        
        if let currentTime = self.player?.currentTime() {
          self.currentTime = CMTimeGetSeconds(currentTime)
        }
        
        if let currentTrack = self.currentTrack, self.currentTime >= Double(currentTrack.duration - 1) {
          self.finishTrack()
        }
      }
      .store(in: &cancellables)
  }
  
  func selectTrack(track: Track, tracks: [Track]) {
    self.currentTrack = track
        
    if let currentTrack, let currentTrackIndex = tracks.firstIndex(of: currentTrack) {
      self.trackQueue = Array(tracks.suffix(from: currentTrackIndex))
      self.currentTrackIndex = 0
    }
  }
  
  func addToPlayNext(track: Track) {
    self.trackQueue.insert(track, at: self.currentTrackIndex + 1)
  }
  
  func playPauseTrack() {
    if self.player?.rate ?? 0 > 0 {
      self.player?.pause()
      self.isPlaying = false
    } else {
      self.player?.play()
      self.isPlaying = true
    }
  }
  
  func nextTrack() {
    if self.isHaveNextTrack {
      self.currentTrackIndex += 1
      self.currentTrack = self.trackQueue[self.currentTrackIndex]
    }
  }
  
  func previousTrack() {
    if self.isHavePreviousTrack {
      self.currentTrackIndex -= 1
      self.currentTrack = self.trackQueue[self.currentTrackIndex]
    } else {
      self.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }
  }
  
  func seek(to time: CMTime) {
    self.player?.seek(to: time)
  }
  
  func finishTrack() {
    if self.isHaveNextTrack {
      self.nextTrack()
    } else {
      self.isPlaying = false
      self.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
      self.player?.pause()
    }
  }
}

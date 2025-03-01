//
//  MockAVPlayer.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 02/03/25.
//

import AVFoundation

protocol AVPlayerProtocol {
  var currentItem: AVPlayerItem? { get }
  var rate: Float { get }
  func play()
  func pause()
  func replaceCurrentItem(with item: AVPlayerItem?)
  func currentTime() -> CMTime
  func seek(to time: CMTime)
}

extension AVPlayer: AVPlayerProtocol {}

class MockAVPlayer: AVPlayerProtocol {
  var currentItem: AVPlayerItem?
  var rate: Float = 0
  
  var mockCurrentTime: CMTime = .zero
  
  func currentTime() -> CMTime {
    return self.mockCurrentTime
  }
  
  func seek(to time: CMTime) {
    self.mockCurrentTime = time
  }
  
  func play() {
    rate = 1.0
  }
  
  func pause() {
    rate = 0.0
  }
  
  func replaceCurrentItem(with item: AVPlayerItem?) {
    currentItem = item
  }
}

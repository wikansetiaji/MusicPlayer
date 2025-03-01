//
//  TrackPlayerTests.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 02/03/25.
//

import XCTest
import Combine
import AVKit
@testable import MusicPlayer

class TrackPlayerTests: XCTestCase {
  
  var sut: TrackPlayer!
  var mockTrack: Track!
  var mockTracks: [Track]!
  
  override func setUp() {
    super.setUp()
    sut = TrackPlayer(playerFactory: { _ in
      MockAVPlayer()
    })
    mockTrack = Track(
      id: "1",
      name: "Track 1",
      duration: 64,
      artistName: "Artist",
      albumName: "Album",
      albumId: "404140",
      audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
    )
    mockTracks = [
      mockTrack,
      Track(
        id: "2",
        name: "Track 2",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "3",
        name: "Track 3",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      )
    ]
  }
  
  override func tearDown() {
    sut = nil
    mockTrack = nil
    mockTracks = nil
    super.tearDown()
  }
  
  func testSelectTrack() {
    // When
    sut.selectTrack(track: mockTrack, tracks: mockTracks)
    
    // Then
    XCTAssertEqual(sut.currentTrack, mockTrack)
    XCTAssertEqual(sut.trackQueue, mockTracks)
    XCTAssertEqual(sut.currentTrackIndex, 0)
  }
  
  func testPlayPauseTrack() {
    // When
    sut.player = MockAVPlayer()
    sut.playPauseTrack()
    
    // Then
    XCTAssertTrue(self.sut.isPlaying)
    
    // When
    self.sut.playPauseTrack()
    
    // Then
    XCTAssertFalse(self.sut.isPlaying)
  }
  
  func testNextTrack() {
    // Given
    sut.selectTrack(track: mockTrack, tracks: mockTracks)
    
    // When
    sut.nextTrack()
    
    // Then
    XCTAssertEqual(sut.currentTrack, mockTracks[1])
    XCTAssertEqual(sut.currentTrackIndex, 1)
  }
  
  func testPreviousTrack() {
    // Given
    sut.selectTrack(track: mockTrack, tracks: mockTracks)
    sut.nextTrack()
    
    // When
    sut.previousTrack()
    
    // Then
    XCTAssertEqual(sut.currentTrack, mockTracks[0])
    XCTAssertEqual(sut.currentTrackIndex, 0)
  }
  
  func testSeek() {
    // Given
    sut.currentTrack = mockTrack
    let expectation = XCTestExpectation(description: "Seek success")
    let seekTime = CMTime(seconds: 40, preferredTimescale: 1)
    
    // When
    self.sut.seek(to: seekTime)
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      XCTAssertEqual(self.sut.currentTime, 40)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 3)
  }
  
  func testFinishTrack() {
    // Given
    sut.selectTrack(track: mockTrack, tracks: mockTracks)
    sut.currentTime = Double(mockTrack.duration - 1) // Simulate track nearing end
    
    // When
    sut.finishTrack()
    
    // Then
    XCTAssertEqual(sut.currentTrack, mockTracks[1])
    XCTAssertEqual(sut.currentTrackIndex, 1)
  }
  
  func testAddToPlayNext() {
    // Given
    sut.selectTrack(track: mockTrack, tracks: mockTracks)
    let newTrack = Track(
      id: "1",
      name: "Track 1",
      duration: 64,
      artistName: "Artist",
      albumName: "Album",
      albumId: "404140",
      audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
    )
    
    // When
    sut.addToPlayNext(track: newTrack)
    
    // Then
    XCTAssertEqual(sut.trackQueue.count, mockTracks.count + 1)
    XCTAssertEqual(sut.trackQueue[sut.currentTrackIndex + 1], newTrack)
  }
}

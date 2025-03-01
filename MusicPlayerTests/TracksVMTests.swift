//
//  MusicPlayerTests.swift
//  MusicPlayerTests
//
//  Created by Wikan Setiaji on 28/02/25.
//

import XCTest
import Combine
@testable import MusicPlayer

class TracksVMTests: XCTestCase {
  
  var sut: TracksVM!
  var mockRepository: MockMusicRepository!
  
  override func setUp() {
    super.setUp()
    mockRepository = MockMusicRepository()
    sut = TracksVM(repository: mockRepository)
  }
  
  override func tearDown() {
    sut = nil
    mockRepository = nil
    super.tearDown()
  }
  
  func testGetTracksSuccess() {
    // Given
    let expectation = XCTestExpectation(description: "Fetch tracks successfully")
    let expectedTracks = [
      Track(
        id: "1",
        name: "Track 1",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      )
    ]
    mockRepository.getTracksResult = .success(TracksResponse(results: expectedTracks, headers: TracksHeader(count: 1, totalCount: 1)))
    
    // When
    sut.getTracks()
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      XCTAssertFalse(self.sut.isLoading)
      XCTAssertEqual(self.sut.tracks, expectedTracks)
      XCTAssertNil(self.sut.error)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 0.2)
  }
  
  func testGetTracksFailure() {
    // Given
    let expectation = XCTestExpectation(description: "Fetch tracks failed")
    let expectedError = APIError.network(message: "mock")
    mockRepository.getTracksResult = .failure(expectedError)
    
    // When
    sut.getTracks()
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      XCTAssertFalse(self.sut.isLoading)
      XCTAssertTrue(self.sut.tracks.isEmpty)
      XCTAssertEqual(self.sut.error, expectedError)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.2)
  }
  
  func testLoadNextPage() {
    // Given
    let expectation = XCTestExpectation(description: "Next page loaded")
    let initialTracks = [
      Track(
        id: "1",
        name: "Track 1",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      )
    ]
    let nextPageTracks = [
      Track(
        id: "2",
        name: "Track 2",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      )
    ]
    mockRepository.getTracksResult = .success(TracksResponse(results: initialTracks, headers: TracksHeader(count: 1, totalCount: 2)))
    
    // When
    sut.getTracks()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.mockRepository.getTracksResult = .success(TracksResponse(results: nextPageTracks, headers: TracksHeader(count: 1, totalCount: 2)))
      self.sut.loadNextPage()
    }
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      XCTAssertFalse(self.sut.isLoadingNextPage)
      XCTAssertEqual(self.sut.tracks, initialTracks + nextPageTracks)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.3)
  }
  
  func testQueryDebounce() {
    // Given
    let expectation = XCTestExpectation(description: "Query debounce")
    let expectedTracks = [
      Track(
        id: "1",
        name: "Track 1",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      )
    ]
    mockRepository.getTracksResult = .success(TracksResponse(results: expectedTracks, headers: TracksHeader(count:1, totalCount: 1)))
    
    // When
    sut.query = "test"
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      expectation.fulfill()
    }
    
    // Then
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(sut.tracks, expectedTracks)
  }
}

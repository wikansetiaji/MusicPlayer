//
//  MockTracksVM.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation

class MockTracksVM: TracksVMProtocol {
  @Published var tracks: [Track] = []
  @Published var offset: Int = 0
  @Published var query: String = ""
  @Published var isLoading: Bool = false
  @Published var isLoadingNextPage: Bool = false
  @Published var error: APIError? = nil
  
  var totalCount: Int = 0
  var canLoadMore: Bool = false
  
  required init(repository: any MusicRepositoryProtocol) {
    self.tracks = [
      Track(
        id: "1532771",
        name: "Track 4",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "1532771",
        name: "Track 4",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "1532771",
        name: "Track 4",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "1532771",
        name: "Track 4",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "1532771",
        name: "Track 4",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        albumId: "404140",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      )
    ]
  }
  
  func getTracks() { }
  
  func loadNextPage() { }
  
}

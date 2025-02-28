//
//  MockTracksVM.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation

class MockTracksVM: TracksVMProtocol {
  @Published var tracks: [Track] = []
  @Published var currentPage: Int = 0
  @Published var query: String = ""
  @Published var isLoading: Bool = false
  @Published var isLoadingNextPage: Bool = false
  @Published var error: APIError? = nil
  
  required init(repository: any MusicRepositoryProtocol) {
    self.tracks = [
      Track(
        id: "id1",
        name: "Track 1",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        image: "https://usercontent.jamendo.com/?type=album&id=404140&width=300&trackid=1532771",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "id2",
        name: "Track 2",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        image: "https://usercontent.jamendo.com/?type=album&id=404140&width=300&trackid=1532771",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "id3",
        name: "Track 3",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        image: "https://usercontent.jamendo.com/?type=album&id=404140&width=300&trackid=1532771",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      ),
      Track(
        id: "id4",
        name: "Track 4",
        duration: 64,
        artistName: "Artist",
        albumName: "Album",
        image: "https://usercontent.jamendo.com/?type=album&id=404140&width=300&trackid=1532771",
        audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
      )
    ]
  }
  
  func getTracks() { }
  
  func loadNextPage() { }
  
}

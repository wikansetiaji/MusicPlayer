//
//  TracksVM.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import Foundation
import Combine
import AVKit

protocol TracksVMProtocol: ObservableObject {
  var tracks: [Track] { get set }
  var offset: Int { get set }
  var query: String { get set }
  var isLoading: Bool { get set }
  var isLoadingNextPage: Bool { get }
  var currentTime: Double { get set }
  var isPlaying: Bool { get set }
  var currentTrack: Track? { get set }
  var error: APIError? { get set }
  var totalCount: Int { get }
  var canLoadMore: Bool { get }
  init(repository: MusicRepositoryProtocol)
  func getTracks()
  func loadNextPage()
  func playPauseTrack()
  func nextTrack()
  func previousTrack()
  func seek(to time: CMTime)
  func finishTrack()
}

class TracksVM: TracksVMProtocol {
  @Published var tracks: [Track] = []
  @Published var isLoading: Bool = false
  @Published var isLoadingNextPage: Bool = false
  @Published var offset: Int = 0
  @Published var query: String = ""
  @Published var error: APIError?
  
  @Published var currentTime: Double = 0
  @Published var isPlaying: Bool = false
  @Published var currentTrack: Track?
  
  var player: AVPlayer?
  var timer: Timer?
  
  var totalCount: Int = 0
  var canLoadMore: Bool {
    self.tracks.count < self.totalCount && !self.isLoading
  }
  
  private var cancellables: Set<AnyCancellable> = []
  private let repository: MusicRepositoryProtocol
  
  required init(repository: MusicRepositoryProtocol) {
    self.repository = repository
    self.setupSubscribings()
  }
  
  func getTracks() {
    if self.offset > 0 {
      self.isLoadingNextPage = true
    } else {
      self.isLoading = true
    }
    self.repository.getTracks(query: self.query, offset: self.tracks.count)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        switch value {
        case .failure(let error):
          self?.isLoading = false
          self?.isLoadingNextPage = false
          self?.error = error
          self?.tracks = []
        case .finished:
          break
        }
      } receiveValue: { [weak self] tracksResponse in
        self?.isLoading = false
        self?.isLoadingNextPage = false
        if self?.offset == 0 {
          self?.tracks = tracksResponse.results
        } else {
          self?.tracks.append(contentsOf: tracksResponse.results)
        }
        self?.totalCount = tracksResponse.headers.totalCount
      }
      .store(in: &cancellables)
  }
  
  func loadNextPage() {
    self.offset = self.tracks.count
  }
  
  func playPauseTrack() {
    if self.player?.rate ?? 0 > 0 {
      self.player?.pause()
      self.isPlaying = false
    } else {
      self.player?.play()
      self.isPlaying = true
      
      self.timer?.invalidate()
      self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        if let currentTime = self.player?.currentTime() {
          self.currentTime = CMTimeGetSeconds(currentTime)
        }
        
        if let currentTrack = self.currentTrack, self.currentTime >= Double(currentTrack.duration - 1) {
          self.finishTrack()
        }
      }
    }
  }
  
  func nextTrack() {
    
  }
  
  func previousTrack() {
    
  }
  
  func seek(to time: CMTime) {
    self.player?.seek(to: time)
  }
  
  func finishTrack() {
    self.isPlaying = false
    self.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    self.player?.pause()

  }
  
  private func setupSubscribings() {
    self.$query
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // Adjust the delay as needed
      .sink { [weak self] _ in
        self?.tracks = []
        self?.offset = 0
      }
      .store(in: &cancellables)
    
    self.$offset
      .sink { [weak self] _ in
        self?.getTracks()
      }
      .store(in: &cancellables)
    
    self.$currentTrack
      .sink { [weak self] track in
        if let audio = track?.audio, let url = URL(string: audio) {
          self?.player = AVPlayer(url: url)
          self?.playPauseTrack()
        }
      }
      .store(in: &cancellables)
  }
}

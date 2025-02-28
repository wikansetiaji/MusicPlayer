//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import SwiftUI
import AVKit

struct TracksPage<Model>: View where Model: TracksVMProtocol {
  @StateObject private var viewModel: Model
  
  init(viewModel: Model) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 10) {
          if self.viewModel.isLoading {
            ProgressView()
          }
          
          ForEach(self.viewModel.tracks) { track in
            TrackCell(track: track, isPlaying: Binding(get: { self.viewModel.currentTrack == track }, set: { _ in }), onPlayNextCommand: {
              self.viewModel.addToPlayNext(track: track)
            })
              .contentShape(Rectangle())
              .onTapGesture {
                self.viewModel.selectTrack(track: track)
              }
            Divider()
          }
          
          if self.viewModel.canLoadMore {
            ProgressView()
              .task {
                self.viewModel.loadNextPage()
              }
          }
          
          if self.viewModel.currentTrack != nil {
            Spacer(minLength: 120)
          }
        }
        .padding()
      }
      .overlay(content: {
        if self.viewModel.currentTrack != nil {
          TrackPlayer(
            currentTime: $viewModel.currentTime,
            isPlaying: $viewModel.isPlaying,
            currentTrack: $viewModel.currentTrack,
            onPlayPauseCommand: {
              self.viewModel.playPauseTrack()
            },
            onNextCommand: {
              self.viewModel.nextTrack()
            },
            onPreviousCommand: {
              self.viewModel.previousTrack()
            },
            onSeek: { currentTime in
              let time = CMTime(seconds: currentTime, preferredTimescale: 1)
              self.viewModel.seek(to: time)
            }
          )
        }
      })
      .navigationTitle("Music Player")
      .navigationBarTitleDisplayMode(.automatic)
      .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search music")
    }
    .tint(.orange)
    .onAppear {
      self.viewModel.getTracks()
    }
  }
}

#Preview {
  TracksPage(viewModel: MockTracksVM(repository: MusicRepository()))
}

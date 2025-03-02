//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import SwiftUI
import AVKit

struct TracksPage<Model, PlayerTool>: View where Model: TracksVMProtocol, PlayerTool: TrackPlayerProtocol {
  @StateObject private var viewModel: Model
  @StateObject private var trackPlayer: PlayerTool
  
  init(viewModel: Model, trackPlayer: PlayerTool) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _trackPlayer = StateObject(wrappedValue: trackPlayer)
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 10) {
          if self.viewModel.isLoading {
            ProgressView()
          }
          
          ForEach(self.viewModel.tracks) { track in
            TrackCell(
              track: track,
              isPlaying: Binding(
                get: { self.trackPlayer.currentTrack == track },
                set: { _ in }),
              onPlayNextCommand: {
                self.trackPlayer.addToPlayNext(track: track)
              }
            )
            .contentShape(Rectangle())
            .onTapGesture {
              self.trackPlayer.selectTrack(
                track: track,
                tracks: self.viewModel.tracks
              )
            }
            Divider()
          }
          
          if self.viewModel.canLoadMore {
            ProgressView()
              .task {
                self.viewModel.loadNextPage()
              }
          }
          
          if self.trackPlayer.currentTrack != nil {
            Spacer(minLength: 120)
          }
        }
        .padding()
      }
      .alert(
        "Oops, error occured:\n" + (self.viewModel.error?.message ?? "Error"),
        isPresented: Binding(
          get: { return self.viewModel.error != nil },
          set: { _ in  }
        )) {
          Button("Try Again", role: .cancel) {
            self.viewModel.query = ""
            self.viewModel.error = nil
          }
        }
      .overlay(content: {
        if self.trackPlayer.currentTrack != nil {
          TrackPlayerView(trackPlayer: TrackPlayer.shared)
        }
      })
      .navigationTitle("Free Music Player 🎧")
      .navigationBarTitleDisplayMode(.automatic)
      .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search free music (provided by Jamendo API)")
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .tint(.orange)
    .onAppear {
      self.viewModel.getTracks()
    }
  }
}

#Preview {
  TracksPage(viewModel: MockTracksVM(repository: MusicRepository()), trackPlayer: MockTrackPlayer())
}

//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import SwiftUI

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
            TrackCell(track: track)
            Divider()
          }
          
          if self.viewModel.canLoadMore {
            ProgressView()
              .task {
                self.viewModel.loadNextPage()
              }
          }
        }
        .padding()
      }
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

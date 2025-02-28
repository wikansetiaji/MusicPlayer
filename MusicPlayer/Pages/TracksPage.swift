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
      List {
        ForEach(viewModel.tracks) { track in
          Text("\(track.artistName) \(track.name)")
        }
      }
      .navigationTitle("Music Player")
      .navigationBarTitleDisplayMode(.automatic)
      .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search music")
    }
    .onAppear {
      self.viewModel.getTracks()
    }
  }
}

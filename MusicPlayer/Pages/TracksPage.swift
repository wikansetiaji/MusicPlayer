//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import SwiftUI

struct TracksPage <Model>: View where Model:TracksVMProtocol {
  @StateObject private var viewModel: Model
  init (viewModel: Model) {
      _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, music player!")
        ForEach(viewModel.tracks) { track in
          Text(track.name)
        }
      }
      .padding()
      .navigationTitle("Music Player")
    }
  }
}

#Preview {
  TracksPage(viewModel: MockTracksVM(repository: MusicRepository()))
}

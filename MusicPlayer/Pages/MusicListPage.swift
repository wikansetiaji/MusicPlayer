//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import SwiftUI

struct MusicListPage: View {
  var body: some View {
    NavigationView {
      ZStack {
        VStack {
          Image(systemName: "globe")
            .imageScale(.large)
            .foregroundStyle(.tint)
          Text("Hello, music player!")
        }
        .padding()
      }
      .navigationTitle("Music Player")
    }
  }
}

#Preview {
  MusicListPage()
}

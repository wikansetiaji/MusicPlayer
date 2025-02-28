//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 28/02/25.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
  var body: some Scene {
    WindowGroup {
      TracksPage(viewModel: TracksVM(repository: MusicRepository()))
    }
  }
}

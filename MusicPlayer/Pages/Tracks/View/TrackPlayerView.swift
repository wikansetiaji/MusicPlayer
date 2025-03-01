//
//  TrackPlayer.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 01/03/25.
//

import SwiftUI
import AVKit

struct TrackPlayerView<PlayerTool>: View where PlayerTool: TrackPlayerProtocol {
  @StateObject private var trackPlayer: PlayerTool
  
  init(trackPlayer: PlayerTool) {
    _trackPlayer = StateObject(wrappedValue: trackPlayer)
  }
  
  var body: some View {
    if let currentTrack = self.trackPlayer.currentTrack {
      VStack {
        Spacer()
        VStack {
          HStack(spacing: 10) {
            AsyncImage(url: URL(string: currentTrack.image)) { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
            } placeholder: {
              Color.gray
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading, spacing: 5) {
              Text("\(currentTrack.name)")
              Text("\(currentTrack.artistName) • \(currentTrack.albumName)")
                .font(.caption)
            }
            
            Spacer()
            
            Button(action: {
              self.trackPlayer.previousTrack()
            }) {
              Image(systemName: "backward.fill")
                .font(.title2)
            }
            
            Button(action: {
              self.trackPlayer.playPauseTrack()
            }) {
              if self.trackPlayer.isPlaying {
                Image(systemName: "pause.fill")
                  .font(.title2)
              } else {
                Image(systemName: "play.fill")
                  .font(.title2)
              }
            }
            
            Button(action: {
              self.trackPlayer.nextTrack()
            }) {
              Image(systemName: "forward.fill")
                .font(.title2)
            }
          }
          
          MusicSlider(value: self.$trackPlayer.currentTime, maximumValue: Double(currentTrack.duration), onSeek: {
            self.trackPlayer.seek(to: CMTime(seconds: $0, preferredTimescale: 1))
          })
        }
        .padding(15)
        .background(Color(UIColor.tertiarySystemBackground).cornerRadius(5))
        .shadow(radius: 4)
      }
      .padding(10)
    }
  }
}


struct MusicSlider: UIViewRepresentable {
  @Binding var value: Double
  var maximumValue: Double
  var onSeek: ((Double) -> Void)?
  
  func makeUIView(context: Context) -> UISlider {
    let slider = UISlider()
    slider.minimumValue = 0
    slider.maximumValue = Float(maximumValue)
    slider.value = Float(value)
    slider.addTarget(
      context.coordinator,
      action: #selector(Coordinator.valueChanged(_:)),
      for: .valueChanged
    )
    return slider
  }
  
  func updateUIView(_ uiView: UISlider, context: Context) {
    uiView.value = Float(value)
    uiView.maximumValue = Float(maximumValue)
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject {
    var parent: MusicSlider
    
    init(_ parent: MusicSlider) {
      self.parent = parent
    }
    
    @objc func valueChanged(_ sender: UISlider) {
      parent.onSeek?(Double(sender.value))
    }
  }
}

#Preview {
  TrackPlayerView(trackPlayer: MockTrackPlayer())
}

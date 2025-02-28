//
//  TrackPlayer.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 01/03/25.
//

import SwiftUI

struct TrackPlayer: View {
  @Binding var currentTime: Double
  @Binding var isPlaying: Bool
  @Binding var currentTrack: Track?
  
  var onPlayPauseCommand: (() -> Void)?
  var onNextCommand: (() -> Void)?
  var onPreviousCommand: (() -> Void)?
  var onSeek: ((Double) -> Void)?
  
  var body: some View {
    if let currentTrack {
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
              self.onPreviousCommand?()
            }) {
              Image(systemName: "backward.fill")
                .font(.title2)
            }
            
            Button(action: {
              self.onPlayPauseCommand?()
            }) {
              if self.isPlaying {
                Image(systemName: "pause.fill")
                  .font(.title2)
              } else {
                Image(systemName: "play.fill")
                  .font(.title2)
              }
            }
            
            Button(action: {
              self.onNextCommand?()
            }) {
              Image(systemName: "forward.fill")
                .font(.title2)
            }
          }
          
          MusicSlider(value: $currentTime, maximumValue: Double(currentTrack.duration), onSeek: {
            self.onSeek?($0)
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

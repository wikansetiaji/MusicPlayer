//
//  TrackCell.swift
//  MusicPlayer
//
//  Created by Wikan Setiaji on 01/03/25.
//

import SwiftUI

struct TrackCell: View {
  @State var track: Track
  @Binding var isPlaying: Bool
  
  var onPlayNextCommand: (() -> Void)?
  
  var body: some View {
    HStack(spacing: 15) {
      AsyncImage(url: URL(string: track.image)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      } placeholder: {
        Color.gray
      }
      .frame(width: 50, height: 50)
      .clipShape(RoundedRectangle(cornerRadius: 5))
      
      VStack(alignment: .leading, spacing: 5) {
        Text("\(track.name)")
        Text("\(track.artistName) • \(track.albumName)")
          .font(.caption)
      }
      
      Spacer()
      
      if self.isPlaying {
        Image(systemName: "waveform.circle.fill")
      }
      
      Menu {
        Button(action: {
          self.onPlayNextCommand?()
        }) {
          Label("Play Next", systemImage: "text.line.first.and.arrowtriangle.forward")
        }
      } label: {
          Image(systemName: "ellipsis.circle")
          .font(.title2)
      }
    }
  }
}

#Preview {
  TrackCell(
    track: Track(
      id: "1532771",
      name: "Track 4",
      duration: 64,
      artistName: "Artist",
      albumName: "Album",
      albumId: "404140",
      audio: "https://prod-1.storage.jamendo.com//?trackid=1532771&format=mp31&from=kg3iQpAJ9vhtDlU89LTD5g%3D%3D%7Cwxlh%2Fmd2tY%2BVMeqNx0tilg%3D%3D"
    ),
    isPlaying: .constant(true),
    onPlayNextCommand: { })
}

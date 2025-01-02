//
//  LoopingVideoPlayerView.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import SwiftUI
import AVKit

struct LoopingVideoPlayerView: View {
    let videoURL: URL

    @State private var player: AVPlayer?
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                setupPlayer()
            }
            .onDisappear {
                cleanupPlayer()
            }
    }
    private func setupPlayer() {
       let newPlayer = AVPlayer(url: videoURL)
       newPlayer.actionAtItemEnd = .none

       // Observe when the video ends
       NotificationCenter.default.addObserver(
           forName: .AVPlayerItemDidPlayToEndTime,
           object: newPlayer.currentItem,
           queue: .main
       ) { _ in
           newPlayer.seek(to: .zero)
           newPlayer.play()
       }
       self.player = newPlayer
       newPlayer.play()
   }
    private func cleanupPlayer() {
        // Stop playback
        player?.pause()
        player = nil // Release the player

        // Remove observer
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}





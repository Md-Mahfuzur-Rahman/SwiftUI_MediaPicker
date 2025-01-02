//
//  MediaDetailContentView.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import SwiftUI
 

struct MediaDetailContentView: View {
    let mediaItem: MediaItem

    var body: some View {
        ZStack {
            if let image = mediaItem.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
            } else if (mediaItem.mediaType == .video)  {
                LoopingVideoPlayerView(videoURL: mediaItem.filePath)
                    .ignoresSafeArea()
            } else {
                Text("Media not available")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
    }
}

//
//  MediaCellView.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import SwiftUI


struct MediaCellView: View {
    let media: MediaItem
    var isSelected: Bool
    
    var body: some View {
        ZStack {
             
            if media.mediaType.isPhotoType, let image = media.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if media.mediaType.isVideoType, let image = media.image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
        }
        //.frame(height: calculateCellHeight(for: media))
        .frame(width: (CommonConstants.screenWidth/2)-20 )
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(isSelected ? Color.theme.lightred : Color.clear, lineWidth: 3)
        })
    }

    private func calculateCellHeight(for mediaItem: MediaItem) -> CGFloat {
        if let image = mediaItem.image {
            let aspectRatio = image.size.height / image.size.width
            return 100 * aspectRatio
        } else if let asset = mediaItem.avAsset {
            let tracks = asset.tracks(withMediaType: .video)
            if let track = tracks.first {
                let size = track.naturalSize.applying(track.preferredTransform)
                let aspectRatio = abs(size.height / size.width)
                return 100 * aspectRatio
            }
        }
        return 100 // Default square size
    }
}





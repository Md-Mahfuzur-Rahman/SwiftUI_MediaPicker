//
//  Extensions.swift
//  Tezza_Assignment
//
//  Created by Mahfuz on 2024-12-25.
//

import Foundation
import SwiftUI
import AVFoundation
import Photos 

extension Color {
    static let theme = ThemeColor()
}

struct ThemeColor {
    let brown = Color("themebrown")
    let dardred = Color("themedardred")
    let lightred = Color("themelightred")
    let grayLight = Color.gray.opacity(0.3)
    let grayMedium = Color.gray.opacity(0.5)
    let grayDark = Color.gray.opacity(0.8)
}

extension String {
 
}

extension Double {
    //MARK: move to utility class
    //func formatDuration(_ duration: Double) -> String {
    func formatDuration() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}


extension AVAsset {
    //func generateThumbnail(for asset: AVAsset) -> UIImage? {
    func generateThumbnail() -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Failed to generate thumbnail: \(error)")
            return nil
        }
    }
}

extension PHAsset {
    
    func getMediaType() -> AssetType {
        let asset:PHAsset = self
        var mediaType:AssetType = .unknown
        
        switch asset.mediaType {
        case .image:
            mediaType = .photo
            if asset.mediaSubtypes.contains(.photoLive) {
                mediaType = .photoLive
            }
            else if asset.mediaSubtypes.contains(.photoScreenshot) {
                mediaType = .photo
            }
            else if asset.mediaSubtypes.contains(.photoPanorama) {
                mediaType = .photoPanorama
            }
            else if asset.mediaSubtypes.contains(.photoHDR) {
                mediaType = .photoHDR
            }
            break
        case .video:
            mediaType = .video
            if asset.mediaSubtypes.contains(.videoHighFrameRate) {
                mediaType = .video
            }
            else if asset.mediaSubtypes.contains(.videoTimelapse) {
                mediaType = .videoTimelapse
            }
            else if asset.mediaSubtypes.contains(.videoCinematic) {
            }
            break
        case .unknown:
            print("=== .unknown media type ")
        case .audio:
            print("=== .audio media type ")
        default:
                print("=== Other media type.")
            }
        return mediaType
    }
}

func getUIImage(assetType : AssetType) -> UIImage? {
    var img:UIImage? = UIImage()
    if assetType == .photoPanorama  {
        img = UIImage(systemName: "pano.fill")
    }
    else if assetType == .photoLive {
        img = UIImage(systemName: "livephoto")
    }
    else if assetType == .video {
        img = UIImage(systemName: "video.fill")
    }
    else if assetType == .videoslowmo {
        img = UIImage(systemName: "slowmo")
    }
    else if assetType == .videoTimelapse {
        img = UIImage(systemName: "timelapse")
    }
    return img
}



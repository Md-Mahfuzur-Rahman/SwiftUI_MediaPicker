//
//  CustomPickerModel.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import Foundation
import SwiftUI
import Photos
import AVFoundation

// ------------------  Picker  Model  ------------------
enum AssetType : Int {
    case photo
    case photoLive
    //case photoScreenshot
    case photoPanorama
    case photoHDR
    
    case video
    case videoslowmo
    case videoTimelapse
    case unknown

    var isPhotoType:Bool {
        return [.photo, .photoHDR, .photoLive, .photoPanorama].contains(self)
    }
    var isVideoType:Bool {
        return [.video, .videoslowmo, .videoTimelapse].contains(self)
    }
}

struct AssetItem : Identifiable, Hashable {
    //let id: String = UUID().uuidString
    let id: Int
    let phasset:PHAsset
    var assetType:AssetType = .photo
    
    init(id:Int, phasset: PHAsset) {
        self.id = id
        self.phasset = phasset
        self.assetType = phasset.getMediaType()
    }
}


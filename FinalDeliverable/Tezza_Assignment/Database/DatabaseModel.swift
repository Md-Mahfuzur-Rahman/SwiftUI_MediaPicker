//
//  DatabaseModel.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import Foundation
import RealmSwift
import SwiftUI
import AVFoundation
import Photos


//-----------------------------
class SavedAsset: Object {
    @Persisted(primaryKey: true) var id:String = UUID().uuidString
    @Persisted var assetType: Int // "photo" or "video"
    @Persisted var fileName: String   // save only fileName, without fullpath of Document dir, while fetching concat Docu..
    @Persisted var savedDate:Date = Date()

    convenience init(assetType: AssetType, fileName: String) {
        self.init()
        self.assetType = assetType.rawValue
        self.fileName = fileName
    }
}

//-----------------------------
//MARK: Separate MediaItem, one for Photo and one for Video
//
struct MediaItem: Identifiable , Hashable{
    let id :String                  
    let filePath: URL
    let mediaType: AssetType
    var avAsset: AVAsset? = nil // Optional since not all items may be videos
    var image: UIImage? = nil
    var thumbnail: UIImage? = nil
    var savedDate:Date?
    
    init(id:String, filePath: URL, mediaType: AssetType, avAsset: AVAsset? = nil,
         image: UIImage? = nil, thumbnail: UIImage? = nil, savedDate: Date? = nil) {
        self.id = id
        self.filePath = filePath
        self.mediaType = mediaType
        self.avAsset = avAsset
        self.image = image
        self.thumbnail = thumbnail
        self.savedDate = savedDate
        
        let type = mediaType
        if type == .unknown {
            print("=== must handle this")
        }
        if image == nil && type.isPhotoType {
            if let image = UIImage(contentsOfFile: filePath.path) {
                self.image = image
            }
        }
        if avAsset == nil && type.isVideoType {
            let avAsset = AVAsset(url: filePath)
            self.avAsset = avAsset
            self.thumbnail = avAsset.generateThumbnail()
        }
    }
}



//
//  DatabaseViewModel.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import Foundation
import RealmSwift
import SwiftUI
import AVFoundation
import Photos

class DatabaseViewModel: ObservableObject {
    @Published var savedAssets: [SavedAsset] = []
    @Published var mediaItems: [MediaItem] = []
    private let dbManager: DatabaseManagerProtocol
    @Published var bAssetsLoaded:Bool = false

    // dependency injection: send RealmDBManager() from where this will be called
    init(dbManager: DatabaseManagerProtocol) {
        self.dbManager = dbManager
    }
    func loadAssets() async {
        //bAssetsLoaded = false
        //print("========== start : bAssetsLoaded = \(bAssetsLoaded) ")
        let savedAssets:[SavedAsset] = await dbManager.fetchAllAssets()
        //if savedAssets.count <= 0 { return }
        //print("===  Loaded Assets = \(savedAssets.count)")

        let allMediaItems = savedAssets.compactMap{ savedAsset -> SavedAsset? in
            let fullPath = CommonConstants.dirPath.appendingPathComponent(savedAsset.fileName)
            if FileManager.default.fileExists(atPath: fullPath.path) == false {
                return nil
            }
            return savedAsset
        }.map { savedAsset -> MediaItem in
            let fullPathUrl = CommonConstants.dirPath.appendingPathComponent(savedAsset.fileName) 
            return MediaItem(id: savedAsset.id, filePath: fullPathUrl,
                             mediaType: AssetType(rawValue: savedAsset.assetType) ?? .photo ,
                             savedDate: savedAsset.savedDate)
        }
        await MainActor.run(body: {
            withAnimation {
                self.mediaItems = allMediaItems
                bAssetsLoaded = true
            }
            //print("========== done : bAssetsLoaded = \(bAssetsLoaded) ")
        })
    }
    func saveSelectedItems(selectedItems: [AssetItem] ) async throws {
        do {
            let documentsURL = CommonConstants.dirPath
            
            var savedAssets:[SavedAsset] = []
            // Transform data here
            for item in selectedItems {
                var fileName: String? = nil
                let type = item.assetType
                if (type.isPhotoType) {
                    fileName = try await savePhoto(asset: item.phasset, to: documentsURL)
                    
                } else if (type.isVideoType) {
                    fileName = try await saveVideo(asset: item.phasset, to: documentsURL)
                }else if (type == .unknown) {
                    print("=== handle this later ")
                }
                if let fileName = fileName {
                    let savedAsset = SavedAsset(assetType: item.assetType, fileName: fileName)
                    savedAssets.append(savedAsset)
                }
            }
            try await dbManager.saveSelectedAssets(selectedAssets: savedAssets)
            //after adding items to DB, loading again
            await loadAssets()
        } catch {
            print("=== Error saving asset: \(error)")
        }
    }
    func savePhoto(asset: PHAsset, to directory: URL) async throws -> String {
        let fileName = UUID().uuidString + ".jpeg"
        let fileURL = directory.appendingPathComponent(fileName)
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, error in
                // MARK: need to handle
//                if let error = error {
//                    continuation.resume(throwing: error  )
//                    return
//                }
                guard let data = data else {
                    continuation.resume(throwing: NSError(domain: "PhotoSavingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image data"]))
                    return
                }
                do {
                    try data.write(to: fileURL)
                    //continuation.resume(returning: fileURL)
                    continuation.resume(returning: fileName)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    func saveVideo(asset: PHAsset, to directory: URL) async throws -> String {
        let fileName = UUID().uuidString + ".mov"
        let fileURL = directory.appendingPathComponent(fileName)

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, error in
                // MARK: need to handle
//                if let error = error {
//                    continuation.resume(throwing: error )
//                    return
//                }
                guard let urlAsset = avAsset as? AVURLAsset else {
                    continuation.resume(throwing: NSError(domain: "VideoSavingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve AVURLAsset"]))
                    return
                }
                do {
                    try FileManager.default.copyItem(at: urlAsset.url, to: fileURL)
                    //continuation.resume(returning: fileURL)
                    continuation.resume(returning: fileName)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /*Deleting the File from the Document Directory First. file deletion might fail.
     This prevents creating a mismatch between the file system and the database. */
    func deleteAssets(ids: [String]) async {
        do {
            // converting for fast lookup
            let setIDs = Set(ids)
            let selectedItems = self.mediaItems.filter { setIDs.contains($0.id) }
            // first delete media from document directory
            let success = deleteFiles(mediaItems: selectedItems)
            if success == false {
                // MARK: one or more files could not be deleted from Document directory
                print("one or more files could not be deleted from Document directory, handle this later ")
            }

            try await dbManager.deleteAssets(withID: ids)

            await loadAssets()
        } catch {
            print("Error deleting asset: \(error)")
        }
    }
    //-------------------------------- Start
    //
    // delete files from local storage
    //
    func deleteFiles(mediaItems: [MediaItem]) -> Bool {
        var retSuccess = true
        mediaItems.forEach { media in
            let success = deleteFile(pathUrl: media.filePath)
            if success {
                print("Deleted file: \(media.filePath)")
            } else {
                print("Failed to delete file: \(media.filePath)")
                retSuccess = success
            }
        }
        return retSuccess
    }
    func deleteFile(pathUrl: URL) -> Bool {
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: pathUrl.path) {
                try fileManager.removeItem(at: pathUrl)
                print("File deleted successfully at path: \(pathUrl)")
                return true
            } else {
                print("File does not exist at path: \(pathUrl)")
                return false
            }
        } catch {
            print("Failed to delete file: \(error.localizedDescription)")
            return false
        }
    }
    //-------------------------------- End
    
    /*  // 'requestImageData(for:options:resultHandler:)' was deprecated in iOS 13
    func savePhoto_v1(asset: PHAsset, to directory: URL) -> URL {
        let fileName = UUID().uuidString + ".jpeg"
        let fileURL = directory.appendingPathComponent(fileName)

        let options = PHImageRequestOptions()
        options.isSynchronous = true
                
        PHImageManager.default().requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                try? data.write(to: fileURL)
            }
        }
        return fileURL
    }
    func saveVideo_v1(asset: PHAsset, to directory: URL) -> URL {
        let fileName = UUID().uuidString + ".mov"
        let fileURL = directory.appendingPathComponent(fileName)

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            if let urlAsset = avAsset as? AVURLAsset {
                try? FileManager.default.copyItem(at: urlAsset.url, to: fileURL)
            }
        }
        return fileURL
    }
    func deleteAsset(id: String) async {
        do {
            try await dbManager.deleteAsset(withID: id)
            await loadAssets()
        } catch {
            print("Error deleting asset: \(error)")
        }
    }*/
    
}









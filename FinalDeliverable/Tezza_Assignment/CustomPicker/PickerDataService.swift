//
//  PickerDataService.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import Foundation
import SwiftUI
import Combine
import Photos

// ------------------  Picker Data Service

// ------------------  Fetch Media Data  ------------------
protocol FetchMediaDataService {
    func fetchMediaData()
}

// ------------------  Fetch Media Data Local  ------------------
class FetchMediaDataServiceLocal: FetchMediaDataService {
    @Published var mediaAssets: [PHAsset] = []
    //@Published var isLoading: Bool = false
    
    init() {
        fetchMediaData()
    }
    func fetchMediaData(){
        Task {
            let assets = await self.fetchMediaAsync()
            mediaAssets = assets
        }
    }
    private func fetchMediaAsync() async -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d OR mediaType = %d",
                                             PHAssetMediaType.image.rawValue,
                                             PHAssetMediaType.video.rawValue)

        let assets = PHAsset.fetchAssets(with: fetchOptions)
        var fetchedAssets: [PHAsset] = []
        assets.enumerateObjects { asset, index, _ in
            fetchedAssets.append(asset)
        }
        //self.isLoading = false
        return fetchedAssets
    }
    /*
    func fetchMediaData() -> Future<[PHAsset], Error> {
        return Future { promise in
            Task {
                do {
                    let assets = try await self.fetchMediaAsync()
                    promise(.success(assets))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    private func fetchMediaAsync() async -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d OR mediaType = %d",
                                             PHAssetMediaType.image.rawValue,
                                             PHAssetMediaType.video.rawValue)
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        var fetchedAssets: [PHAsset] = []
        assets.enumerateObjects { asset, index, _ in
            fetchedAssets.append(asset)
        }
        return fetchedAssets
    }*/
}

// ------------------  Fetch other Media Data  ------------------

class FetchMediaDataServiceOther: FetchMediaDataService {
    func fetchMediaData(){
    }
}


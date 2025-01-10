//
//  CustomCellViewAsync.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import SwiftUI
import Photos

struct CustomCellViewAsync: View {
    let asset: AssetItem
    @State private var image: UIImage? = nil
    let selectedIndex: Int?
    var isSelected: Bool

    var body: some View {
        GeometryReader { geometry in
            //print("=== View Size: \(geometry.size.width) x \(geometry.size.height) ")
            ZStack() {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: PickerConstants.cellWidth, height: PickerConstants.cellWidth)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isSelected ? Color.theme.dardred : Color.clear, lineWidth: 5)
                        )
                        .cornerRadius(5)
                        .allowsHitTesting(false)
                } else {
                    ProgressView()
                }
                HStack {
                    VStack {
                        if let count = selectedIndex {
                            Text("\(count)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: PickerConstants.infoW, height: PickerConstants.infoH)
                                .background(Circle().fill(Color.theme.lightred))
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 1)
                                )
                                .padding(5)
                        }
                        Spacer()
                    }
                    Spacer()
                    
                    VStack(){
                        if asset.assetType != .photo {
                            Image(uiImage: getUIImage(assetType: asset.assetType) ?? UIImage() )
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: PickerConstants.imgW, height: PickerConstants.imgH, alignment: .trailing)
                                //.scaledToFit()
                                .foregroundColor(Color.white)
                                .padding(5)
                                .shadow(color: .black, radius: 10, x: 0, y: 0) //***: (1) cornerRadius will be before (2) shadow()
                        }
                        Spacer()
                        if asset.assetType == .video {
                            Text(asset.phasset.duration.formatDuration())
                                .font(.caption2)
                                .foregroundColor(Color.white)
                                .frame(width: PickerConstants.infoW+10, height: PickerConstants.infoH, alignment: .center)
                                .shadow(color: .black, radius: 10) //***: (1) cornerRadius will be before (2) shadow()
                                .padding(5)
                        }
                    }
                }
                //.allowsHitTesting(false)
                .frame(width: PickerConstants.cellWidth, height: PickerConstants.cellWidth)
            }
            .contentShape(Rectangle())  // Ensures entire cell is tappable
            .onAppear(){
                fetchThumbnail()
            }
        }
    }
    private func fetchThumbnail() {
        if let cachedImage = ImageCache.shared.getImage(for: asset.phasset.localIdentifier) {
            self.image = cachedImage
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true // Enable fetching iCloud media

        PHImageManager.default().requestImage(
            for: asset.phasset,
            targetSize: CGSize(width: 300, height: 300), // best size
            contentMode: .aspectFill,
            options: options
        ) { result, _ in
            
            DispatchQueue.main.async {
                if let result = result {
                    ImageCache.shared.setImage(result, for: self.asset.phasset.localIdentifier)
                    self.image = result
                    //print("=== fetched from Photos")
                }
            }
        }
    }
    /* MARK: try this later
    // Fetch an image or video data for a given PHAsset
    func fetchMediaData(for asset: PHAsset, completion: @escaping (Result<Data, Error>) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true // Enable fetching iCloud media
        options.deliveryMode = .highQualityFormat
        
        let imageManager = PHImageManager.default()
        
        if asset.mediaType == .image {
            // Fetch image data
            imageManager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, error in
                if let error = error {
                    completion(.failure(error as! Error))
                } else if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "MediaPicker", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred while fetching image data."])))
                }
            }
        } else if asset.mediaType == .video {
            // Fetch video data
            let videoOptions = PHVideoRequestOptions()
            videoOptions.isNetworkAccessAllowed = true
            videoOptions.deliveryMode = .highQualityFormat
            
            imageManager.requestAVAsset(forVideo: asset, options: videoOptions) { avAsset, _, error in
                if let error = error {
                    completion(.failure(error as! Error))
                } else if let urlAsset = avAsset as? AVURLAsset {
                    do {
                        let data = try Data(contentsOf: urlAsset.url)
                        completion(.success(data))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "com.example.MediaPicker", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred while fetching video data."])))
                }
            }
        }
    }*/

}

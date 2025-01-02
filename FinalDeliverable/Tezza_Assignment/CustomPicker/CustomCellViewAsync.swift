//
//  CustomCellViewAsync.swift
//  Tezza_Assignment
//
//  Created by Mahfuz


import SwiftUI
import Photos

struct CustomCellViewAsync: View {
    let asset: AssetItem
    let selectedIndex: Int?
    var isSelected: Bool

    var body: some View {
        ZStack() {
            AsyncImage(asset: asset.phasset, size: CGSize(width: PickerConstants.cellWidth, height: PickerConstants.cellWidth))
                .frame(width: PickerConstants.cellWidth, height: PickerConstants.cellWidth)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        //.stroke(item.isSelected ? Color.red : Color.clear, lineWidth: 2)
                        .stroke(isSelected ? Color.theme.dardred : Color.clear, lineWidth: 5)
                )
            //ProgressView()
            
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
                            .shadow(color: .black, radius: 10, x: 0, y: 0) //***: cornerRadius will be before shadow()
                    }
                    Spacer()
                    if asset.assetType == .video {
                        Text(asset.phasset.duration.formatDuration())
                            .font(.caption2)
                            .foregroundColor(Color.white)
                            .frame(width: PickerConstants.infoW+10, height: PickerConstants.infoH, alignment: .center)
                            .shadow(color: .black, radius: 10) //***: cornerRadius will be before shadow()
                            .padding(5)
                    }
                }
            }
            .frame(width: PickerConstants.cellWidth, height: PickerConstants.cellWidth)
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

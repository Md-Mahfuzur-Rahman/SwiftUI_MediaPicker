//
//  LibraryView.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import SwiftUI
import AVFoundation


struct LibraryView: View {
    @EnvironmentObject var vmDB:DatabaseViewModel
        
    @State private var showPreView = false
    @State private var doubleTappedIndex: Int = 0
    @State private var selectedCellIDs = Set<String>()
    
    var selectedItems: (Set<String>) -> Void

    let columns = 2
    // Divide media into 2 columns
    private var columnedMediaItems: [[MediaItem]] {
        var columnsArray = Array(repeating: [MediaItem](), count: columns)
        var columnHeights = Array(repeating: 0.0, count: columns) // Keeps track of the height sum of each column
        
        for mediaItem in vmDB.mediaItems {
            guard let image = mediaItem.image else { continue }
            let aspectRatio = image.size.height / image.size.width
            
            // Find the column with the least height
            if let shortestColumnIndex = columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset {
                columnsArray[shortestColumnIndex].append(mediaItem)
                columnHeights[shortestColumnIndex] += aspectRatio
            }
        }
        return columnsArray
    }
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: 12) {
                ForEach(columnedMediaItems, id: \.self) { column in
                    VStack(spacing: 12) {
                        ForEach(column) { item in
                            MediaCellView(media: item, isSelected: selectedCellIDs.contains(item.id) )
                                .onTapGesture(count: 2) { // Double-tap gesture
                                    if let index = vmDB.mediaItems.firstIndex(where: { $0.id == item.id }) {
                                        doubleTappedIndex = index
                                    }
                                    showPreView = true
                                }
                                .onTapGesture() {
                                    toggleSelection(id: item.id)
                                    selectedItems(selectedCellIDs)
                                }
                        }
                    }
                    //.background(Color.cyan)
                }
            }
            .padding()
            .scrollIndicators(ScrollIndicatorVisibility.hidden) // iOS 16.0
        }
        .onAppear {
            //MARK: is proper place ?
            Task{
                await vmDB.loadAssets()
            }
        }
        .fullScreenCover(isPresented: $showPreView) {
            MediaDetailView(
                mediaItems: vmDB.mediaItems,
                currentIndex: $doubleTappedIndex
            )
        }
    }
    private func toggleSelection(id: String){
        if selectedCellIDs.contains(id) {
            selectedCellIDs.remove(id)
        }else {
            selectedCellIDs.insert(id)
        }
    }
    
    
}







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
    //let columns = [
      //  GridItem(.adaptive(minimum: 100), spacing: 10) // Adaptive grid for variable sizes
    //]
    let columns = 2
    // Divide photos into multiple columns
    private var columnedMediaItems: [[MediaItem]] {
        var columnsArray = Array(repeating: [MediaItem](), count: columns)
        for (index, mediaItem) in vmDB.mediaItems.enumerated() {
            columnsArray[index % columns].append(mediaItem)
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







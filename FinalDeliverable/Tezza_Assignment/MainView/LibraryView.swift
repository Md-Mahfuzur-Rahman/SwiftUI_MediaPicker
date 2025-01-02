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
    
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 10) // Adaptive grid for variable sizes
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(vmDB.mediaItems) { item in
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







//
//  CustomPickerViewModel.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import Foundation
import SwiftUI
import Combine
import Photos

// ================= Custom Picker ViewModel =================

class PickerViewModel: ObservableObject {
    @Published var mediaItems: [AssetItem] = []
    @Published var selectedItems: Set<AssetItem> = []
    @Published var selectedIndices: [Int] = []
    
    private var dataService = FetchMediaDataServiceLocal()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.dataService.$mediaAssets                    //dataService.fetchMediaData()
            .receive(on: DispatchQueue.main)
            .map({ phassets in
                phassets.enumerated().map { index, phasset in
                    AssetItem(id:index, phasset: phasset) 
                }
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("error : \(error.localizedDescription)")
                    break
                case .finished:
                    print()
                    break
                }
            }, receiveValue: { [weak self] assetItems in
                self?.mediaItems = assetItems
            })
            .store(in: &cancellables)
    }
    func toggleSelection(_ index:Int)  {
        var item = mediaItems[index]
        if selectedItems.contains(item) {
            selectedItems.remove(item)
            selectedIndices.removeAll { $0 == index }
        } else {
            selectedItems.insert(item)
            //selected = true
            selectedIndices.append(index)
        }
        //print("=== selectedIndices = \(selectedIndices)")
    }
    func getPositionIndex(_ index: Int) -> Int? {
        guard let position = selectedIndices.firstIndex(of: index) else {
            return nil
        }
        return position + 1
    }

}



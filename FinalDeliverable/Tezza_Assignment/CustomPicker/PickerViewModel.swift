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

}



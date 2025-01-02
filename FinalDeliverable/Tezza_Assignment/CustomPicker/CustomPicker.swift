//
//  CustomPicker.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import Photos
import SwiftUI
import Combine


// ------------------  Picker   ------------------
//
struct CustomMediaPicker: View {
    @EnvironmentObject var vmDB:DatabaseViewModel
    @StateObject private var vm = PickerViewModel()
    @State private var selectedIndices: [Int] = [] // do not use Set here
    @State var category:MediaCategory = .all
    @Binding var isPresented: Bool

    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 10) // Adaptive grid for variable sizes
    ]

    var body: some View {
        ZStack {
            Color.theme.brown
                .ignoresSafeArea()

            VStack {
                HStack {
                    CircleButtonView(iconName: "clear", colorBack: Color.clear, colorFore: Color.black)
                        .padding(4)
                        .onTapGesture {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    Spacer()
                    Text("Media Picker")
                        .font(.title2)
                        .padding(4)
                        
                    Spacer()
                    
                    CircleButtonView(iconName: "checkmark", colorBack: Color.clear, colorFore: Color.black)
                        .padding(4)
                        .onTapGesture {
                            let items = selectedIndices.map {  vm.mediaItems[$0] } // add all  selected items
                            /* let items = selectedIDs.map({ strOneID -> AssetItem? in
                                if let item = vm.mediaItems.first(where: { assetItem in
                                    assetItem.id == strOneID
                                }) {
                                    return item
                                }
                                return nil
                            })*/
                            isPresented = false
                            //MARK: move this code
                            if items.count > 0 {
                                Task{
                                    try await vmDB.saveSelectedItems(selectedItems: items)
                                }
                            }
                        }
                }
                CustomSegmentedControl(selectedCategory: $category)
                    .frame(width: 210, height: 40, alignment: .center)
                    .padding(10)
                    
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                    //LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 5) {
                        ForEach(vm.mediaItems) { asset in
                            if shouldShowCell(for: asset){
                                CustomCellViewAsync(asset: asset,
                                                    index: asset.id,
                                                    selectedIndices: $selectedIndices )
                                .frame(width: PickerConstants.cellWidth, height: PickerConstants.cellWidth)
                                .cornerRadius(5)
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                }
            }
        }
    }
    func shouldShowCell(for asset: AssetItem) -> Bool {
        let type = asset.assetType
        if category == .all {
            return true
        }
        else if category == .photo && type.isPhotoType  {
            return true
        }
        else if category == .video && type.isVideoType {
            return true
        }
        return false
    }
}






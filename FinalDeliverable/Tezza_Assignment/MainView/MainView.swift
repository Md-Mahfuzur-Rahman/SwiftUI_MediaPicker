//
//  ContentView.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import SwiftUI
import Photos
import Combine


struct MainView: View {
    @EnvironmentObject var vmDB:DatabaseViewModel
    @State private var showPickerView = false
    @State private var selectedItems = Set<String>()
    @State private var enableEditingButtons = false
    @State private var showDeleteAlert = false
    @State private var showPermissionDenied = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.brown  // Background color
                    .ignoresSafeArea()
                
                VStack {
                    LibraryView(selectedItems: { selItems in
                        selectedItems = selItems
                        enableEditingButtons = selectedItems.count > 0 ? true : false
                    })
                    .background(Color.theme.grayLight)

                    Spacer()
                    HStack {
                        if ( vmDB.mediaItems.count > 0) {
                            EditingToolbarView(bEnableButtons: $enableEditingButtons, onButtonTap: { button in
                                editingToolbarButtonPressed(button: button)
                            })
                            .frame(width: UIScreen.main.bounds.width-110, height: CommonConstants.bottomBarHeight) //MARK: no constant

                        }else {
                            Text(CommonConstants.importText)
                                .modifier(CustomLongButton())
                        }
                        
                        CircleButtonView(iconName: "plus", colorBack: Color.yellow, colorFore: Color.black)
                            .onTapGesture {
                                showMediaPcker()
                            }
                    }
                }
            }
            .sheet(isPresented: $showPickerView) {
                //print("-----")
            } content: {
                CustomMediaPicker(isPresented: $showPickerView)
                    .environmentObject(vmDB)
            }
            .alert(CommonConstants.delConfirm, isPresented: $showDeleteAlert, actions: {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAllFiles()
                }
            }, message: {
                Text(CommonConstants.delConfirmMsg)
            } )
            .alert("Permission was denied", isPresented: $showPermissionDenied, actions: {
                Button("Ok", role: .cancel) { }
            }, message: {
                Text(CommonConstants.permissionDenied)
            } )        }
    }
    func editingToolbarButtonPressed(button: CommonButtons) {
        switch button {
        case .Edit:
            print("=== button = \(button)")
        case .Copy:
            print("=== button = \(button)")
        case .Paste:
            print("=== button = \(button)")
        case .Save:
            print("=== button = \(button)")
        case .Delete:
            showDeleteAlert = true
        }
    }
}

extension MainView {
    
    func deleteAllFiles() {
        Task{
            await vmDB.deleteAssets(ids: Array(selectedItems) )
            enableEditingButtons = false
        }
    }
}

//---------------------- Picker Related -------------
//
extension MainView {
    
    func showMediaPcker(){
        Task {
            let msg = await fetchMedia()
            if msg.isEmpty == false {
                showPermissionDenied = true 
            }
        }
    }
    
    @MainActor
    func fetchMedia() async -> String {
        //isLoading = true
        var errorMessage = ""
        do {
            // Request authorization asynchronously
            let status = await requestPhotoLibraryAuthorization()

            switch status {
            case .authorized, .limited:
                showPickerView = true
            case .denied, .restricted:
                errorMessage = "Photo Library access is denied or restricted."
            case .notDetermined:
                errorMessage = "Photo Library access has not been determined."
            @unknown default:
                errorMessage = "An unknown error occurred while accessing the Photo Library."
            }
        } catch {
            // Handle any unexpected errors
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        // Stop loading indicator
        //isLoading = false
        return errorMessage
    }
    func requestPhotoLibraryAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                continuation.resume(returning: status)
            }
        }
    }
}


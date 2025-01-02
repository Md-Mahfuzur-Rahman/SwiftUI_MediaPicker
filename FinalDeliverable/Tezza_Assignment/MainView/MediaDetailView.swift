//
//  MediaDetailView.swift
//  Tezza_Assignment
//
//  Created by Mahfuz
//

import SwiftUI


struct MediaDetailView: View {
    let mediaItems: [MediaItem]
    @Binding var currentIndex: Int
    @Environment(\.dismiss) private var dismiss //dismiss' is only available in iOS 15.0
    
    var body: some View {
        NavigationStack {   //iOS 16.0
            TabView(selection: $currentIndex) {
                ForEach(mediaItems.indices, id: \.self) { index in
                    MediaDetailContentView(mediaItem: mediaItems[index])
                        .tag(index)
                        .background(Color.blue)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .background(Color.theme.brown.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // Navigate back to LibraryView
                    }) {
                        Label("Back", systemImage: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}



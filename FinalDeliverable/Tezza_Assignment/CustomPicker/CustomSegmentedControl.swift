//
//  CustomSegmentedControl.swift
//  Tezza_Assignment
//
//  Created by Mahfuz 
//

import SwiftUI

enum MediaCategory: String , CaseIterable {
    case all, photo, video
}

struct CustomSegmentedControl: View {
    @Binding var selectedCategory: MediaCategory

    var body: some View {
        HStack(spacing: 0) {
            ForEach(MediaCategory.allCases, id: \.self) { category in
                Button(action: {
                    selectCategory(category)
                }) {
                    Text(category.rawValue.capitalized)
                        .font(.caption2)
                        .frame(maxWidth: .infinity, maxHeight: 30)
                        //.background(selectedCategory == category ? Color.red : Color.gray.opacity(0.2))
                        .background(selectedCategory == category ? Color.red : Color.white)
                        .foregroundColor(selectedCategory == category ? .white : .black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)
                        )
                }
            }
        }
        .frame(height: 30)
        .cornerRadius(10)
        .padding(.horizontal)

    }

    private func selectCategory(_ category: MediaCategory) {
        withAnimation {
            selectedCategory = category
        }
    }
}




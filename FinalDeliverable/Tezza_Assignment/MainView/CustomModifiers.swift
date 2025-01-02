//
//  CustomModifiers.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import SwiftUI


struct CustomLongButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: CommonConstants.bottomBarHeight)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color(UIColor.systemGray6))
            )
            .padding(.leading, 20)
    }
}




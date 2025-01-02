//
//  CircleButtonView.swift
//  SwiftUI
//
//  Created by Mahfuz
//

import SwiftUI

struct CircleButtonView: View {
    var iconName:String
    var colorBack:Color
    var colorFore:Color
    
    var body: some View {
        
        ZStack{
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(colorFore)
                .frame(width: 50, height: 50)
                .background {
                    Circle().foregroundColor(colorBack)
                }
                .shadow(radius: 10)
                .padding()
        }
    }
}


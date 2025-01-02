//
//  EditingToolbarView.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import SwiftUI


struct EditingToolbarView : View {
    @Binding var bEnableButtons:Bool
    var onButtonTap: (CommonButtons) -> Void  // callback clouser
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(CommonButtons.allCases, id: \.self) { button in
                VStack {
                    Button(action: {
                        if (bEnableButtons){
                            onButtonTap(button)
                        }
                    }) {
                        Image(systemName: buttonImageName(button: button))
                            .resizable()
                            .frame(width: 20, height: 20)
                            .scaledToFit()
                            // .foregroundColor() working Because of SFSymbol image
                            .foregroundColor(bEnableButtons ? Color.black.opacity(0.6) : Color.black.opacity(0.2))
                    }
                    Text(button.rawValue)
                        .font(.caption)
                        .foregroundColor(bEnableButtons ? Color.black.opacity(0.6) : Color.black.opacity(0.2))
                }
                .padding(1)
            }
        }
        .padding(.leading, 1)
        .frame(maxWidth: .infinity, maxHeight: .infinity) // *** : this is important when u want bigger View
        .transition(.opacity) // Smooth transition
        .cornerRadius(50)
        .background(Color.theme.brown)
//        .background(
//            RoundedRectangle(cornerRadius: 50)
//                .fill(Color(UIColor.systemGray6))
//        )
        .overlay {
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.theme.grayDark, lineWidth: 2)
        }
        
    }
        
    func buttonImageName(button: CommonButtons) -> String {
        switch button {
        case .Edit:
            return "slider.horizontal.3"
        case .Copy:
            return "doc.on.doc"
        case .Paste:
            return "doc.on.clipboard"
        case .Save:
            return "square.and.arrow.down"
        case .Delete:
            return "xmark.bin"
        }
    }
}




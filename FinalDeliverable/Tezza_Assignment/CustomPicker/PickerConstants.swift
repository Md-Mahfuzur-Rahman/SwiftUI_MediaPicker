//
//  PickerConstants.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import Foundation
import SwiftUI


struct PickerConstants {
    static var cellWidth : CGFloat {
        // Dynamically calculate height based on screen width for a 3-column layout
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10 * 4 // Total spacing (3 cells + padding)
        return (screenWidth - spacing) / 3 // Width is divided equally among 3 columns
    }
    static let infoW = 30.0
    static let infoH = 20.0
    static let imgW = 20.0
    static let imgH = 12.0
}




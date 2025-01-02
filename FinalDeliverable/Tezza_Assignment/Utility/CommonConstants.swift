//
//  CommonConstants.swift
//  Tezza_Assignment
//
//  Created by Mahfuz on 2024-12-27.
//

import Foundation
import SwiftUI


enum CommonButtons : String, CaseIterable {
    case Edit
    case Copy
    case Paste
    case Save
    case Delete

//    static var allCases: [CommonButtons]{
//        return [.edit, .copy, .paste, .save, .delete]
//    }
}

struct CommonConstants{
    
    static var dirPath:URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        //let tezzaUrl = documentsURL.appendingPathComponent("Tezza")
        //print("=== tezzaUrl = \(tezzaUrl)")
        return documentsURL
    }
    static let bottomBarHeight = 60.0
    static let delConfirm = "Confirm Delete"
    static let delConfirmMsg = "Are you sure you want to delete from your library? Once it's gone, it's gone."
    static let importText = "IMPORT YOUR MEDIA"
    
    static let permissionDenied = "Permission denied please go to settings and fix it."
    
}

enum RealmError: Error {
    case objectNotFound
    case writeFailed
    case unknown(Error)
}





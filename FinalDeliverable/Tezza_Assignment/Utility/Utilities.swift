//
//  Utilities.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import Foundation
import Photos
import SwiftUI

func getAfterDocuments(fullPath:String) -> String {
    var pathAfterDocuments = ""
    if let documentsRange = fullPath.range(of: "Documents") {
        // Get the substring starting after "Documents/"
        pathAfterDocuments = String(fullPath[documentsRange.upperBound...])
        print(String(pathAfterDocuments))
    } else {
        print("The path does not contain the 'Documents' folder.")
    }
    return pathAfterDocuments
}

/* --------------------------------------------------
 // MARK: ImageCache
 ImageCache will be used to store small thumbnail images of MediaPicker in Dictionary,
 so that if user scroll picker back and forth, no need to
 fetch them from Photos app again and again. But the drawback of this approach is
 "cache: [String: UIImage]" will take a good amount of
 sapce in memory. so need to findout an workaround of this approach
 -------------------------------------------------- */
class ImageCache {
    static let shared = ImageCache()
    private var cache: [String: UIImage] = [:]
    private let lock = NSLock()

    func getImage(for identifier: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        return cache[identifier]
    }

    func setImage(_ image: UIImage, for identifier: String) {
        lock.lock(); defer { lock.unlock() }
        cache[identifier] = image
    }
}




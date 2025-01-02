//
//  RealmDatabase.swift
//  Tezza_Assignment
//
//  Created by Mahfuz  
//

import Foundation
import RealmSwift
import SwiftUI
import AVFoundation
import Photos



protocol DatabaseManagerProtocol {
    func addAsset(assetType: AssetType, fileName: String) async throws
    func saveSelectedAssets(selectedAssets: [SavedAsset] ) async throws
    func deleteAsset(withID id: String) async throws
    func deleteAssets(withID ids: [String]) async throws
    func fetchAllAssets() async -> [SavedAsset]
}
//
// RealmDBManager will be called form DatabaseViewModel
//
actor RealmDBManager: DatabaseManagerProtocol {
    // may be will not use
    func addAsset(assetType: AssetType, fileName: String) async throws {
        let realm = try! await Realm()
        let asset = SavedAsset(assetType: assetType, fileName: fileName)
        try realm.write {
            //realm.add(asset)
            realm.add(asset, update: .modified)
        }
    }
    // will use frequently 
    func saveSelectedAssets(selectedAssets: [SavedAsset] ) async throws {
        let realm = try! await Realm()
        try realm.write {
            for oneAsset in selectedAssets {
                realm.add(oneAsset, update: .modified)
            }
        }
    }
    func deleteAsset(withID id: String) async throws {
        let realm = try! await Realm()
        if let asset = realm.object(ofType: SavedAsset.self, forPrimaryKey: id) {
            try realm.write {
                realm.delete(asset)
            }
        }
    }
    func deleteAssets(withID ids: [String]) async throws {
        let realm = try! await Realm()
        let objectsToDelete = realm.objects(SavedAsset.self).filter("id IN %@", ids)
        try realm.write {
            realm.delete(objectsToDelete)
        }
    }
    func fetchAllAssets() async -> [SavedAsset] {
        let realm = try! await Realm()
        let results = realm.objects(SavedAsset.self).sorted(byKeyPath: "savedDate", ascending: false)
        return Array(results)
    }
}

//-----------------------------------

actor CoreDataManager: DatabaseManagerProtocol {
    func saveSelectedAssets(selectedAssets: [SavedAsset]) async throws {  }
    func addAsset(assetType: AssetType, fileName: String) async throws {  }
    func deleteAsset(withID id: String) async throws        {  }
    func deleteAssets(withID ids: [String]) async throws    {  }
    func fetchAllAssets() -> [SavedAsset] {
        return []
    }
}


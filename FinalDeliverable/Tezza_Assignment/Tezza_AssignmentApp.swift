//
//  Tezza_AssignmentApp.swift
//  Tezza_Assignment
//
//  Created by Mahfuz 
//

import SwiftUI

@main
struct Tezza_AssignmentApp: App {
    @StateObject var vmDB = DatabaseViewModel(dbManager: RealmDBManager())
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(vmDB)
                .onAppear {
                    ShareableRealmDB().setConfig()
                }
        }
    }
}

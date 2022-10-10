//
//  CompanionApp.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import SwiftUI

@main
struct CompanionApp: App {
    @StateObject var store: DataStore = DataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

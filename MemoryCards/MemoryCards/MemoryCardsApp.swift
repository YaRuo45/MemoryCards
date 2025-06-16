//
//  MemoryCardsApp.swift
//  MemoryCards
//
//  Created by Jessica Sun on 21/05/25.
//

import SwiftUI

@main
struct MemoryCardsApp: App {
    @StateObject private var cardModel = CardModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cardModel)
        }
    }
}

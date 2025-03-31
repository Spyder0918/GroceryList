//
//  GroceryListApp.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 3/30/25.
//

import SwiftUI
import SwiftData

@main
struct GroceryListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: GroceryListItem.self)
    }
}

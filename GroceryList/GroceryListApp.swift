//
//  GroceryListApp.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 3/30/25.
//

import SwiftData
import SwiftUI

@main
struct GroceryListApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: GroceryListItem.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}

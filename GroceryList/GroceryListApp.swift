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
            LoginView()
        }
        //.modelContainer(for: GroceryListItem.self)
       // .modelContainer(for: [ShoppingList.self, GroceryListItem.self])
        .modelContainer(for: [ShoppingList.self, GroceryListItem.self], isAutosaveEnabled: true, isUndoEnabled: true)



    }
}

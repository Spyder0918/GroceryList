//
//  GroceryList.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 5/9/25.
//
import SwiftData

@Model
class ShoppingList {
    @Attribute(.unique) var name: String
    var items: [GroceryListItem] = [] // Each list has multiple items

    init(name: String) {
        self.name = name
    }
}


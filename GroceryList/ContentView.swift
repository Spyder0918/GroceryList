// ContentView.swift
// GroceryList
//
// Created by Brandon Jacobs on 3/30/25.

import SwiftData   // Framework for data storage and retrieval
import SwiftUI     // Framework for building user interfaces

struct ContentView: View {
    // Access the model (database) context to insert, delete, and save items
    @Environment(\.modelContext) var context
    
    // State variable to hold the new item's text input
    @State var newItemString = ""

    // Query to fetch all GroceryListItem objects from the database
    @Query var items: [GroceryListItem]

    // Computed property: filters to get only items that are NOT purchased
    var toBuyItems: [GroceryListItem] {
        items.filter { !$0.isPurchased }
    }

    // Computed property: filters to get only items that ARE purchased
    var boughtItems: [GroceryListItem] {
        items.filter { $0.isPurchased }
    }

    var body: some View {
        NavigationView {   // Provides a navigation-style layout
            VStack {       // Stack elements vertically
                // Text field for entering a new grocery item
                TextField("Add item", text: $newItemString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Save button to add the new item to the list
                Button("Save") {
                    // Make sure the text field is not empty
                    guard !newItemString.isEmpty else {
                        return
                    }

                    // Create a new GroceryListItem object
                    let newItem = GroceryListItem(title: newItemString, subtitle: "", date: Date())

                    // Insert the new item into the database
                    context.insert(newItem)

                    // Clear the text field
                    newItemString = ""
                }

                // List view displaying the grocery items
                List {
                    // Section for items not yet purchased
                    Section("Not in Cart") {
                        ForEach(toBuyItems) { item in
                            HStack { // Horizontal stack: icon and text
                                Image(
                                    systemName: item.isPurchased
                                        ? "checkmark.circle.fill" : "circle" // Filled circle if purchased
                                )
                                .foregroundColor(item.isPurchased ? .green : .gray) // Green if purchased
                                .onTapGesture {
                                    withAnimation {
                                        // Toggle purchase status
                                        item.isPurchased.toggle()
                                    }
                                    try? context.save() // Save change to the database
                                }
                                Text(item.title)
                                    .strikethrough(item.isPurchased) // Strike text if purchased
                            }
                        }
                        .onDelete { indexSet in
                            // Allow deleting items
                            indexSet.forEach { index in
                                context.delete(toBuyItems[index])
                            }
                        }
                    }

                    // Section for items already purchased
                    Section("In Cart") {
                        ForEach(boughtItems) { item in
                            HStack {
                                Image(
                                    systemName: item.isPurchased
                                        ? "checkmark.circle.fill" : "circle"
                                )
                                .foregroundColor(item.isPurchased ? .green : .gray)
                                .onTapGesture {
                                    withAnimation {
                                        item.isPurchased.toggle()
                                    }
                                    try? context.save()
                                }
                                Text(item.title)
                                    .strikethrough(item.isPurchased)
                            }
                        }
                        .onDelete { indexSet in
                            // Allow deleting purchased items
                            indexSet.forEach { index in
                                context.delete(boughtItems[index])
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped) // List style with grouped sections

            }
            .overlay {
                // If there are no items, show "No Items" text
                if items.isEmpty {
                    Text("No Items")
                }
            }
        }
        .navigationTitle("Grocery List") // Title of the navigation view
    }
}

// Preview provider for SwiftUI previews
#Preview {
    ContentView()
}


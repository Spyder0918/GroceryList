//
//  GroceryListDetailView.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 3/30/25.
//

import SwiftData
import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool = false) {
        if let windowScene = connectedScenes.first as? UIWindowScene {
            windowScene.windows.filter { $0.isKeyWindow }.first?.endEditing(force)
        }
    }
}

struct GroceryListDetailView: View {
    @Environment(\.modelContext) var context

    // Holds the new item text field input
    @State var newItemString = ""

    // Instead of @Query, we pull the items directly from the specific ShoppingList
    var items: [GroceryListItem] {
        groceryList.items
    }

    @Bindable var groceryList: ShoppingList

    // Items not purchased yet
    var toBuyItems: [GroceryListItem] {
        items.filter { !$0.inCart }
    }

    // Items that have been purchased
    var boughtItems: [GroceryListItem] {
        items.filter { $0.inCart }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Text field for adding a new item
                TextField("Add item", text: $newItemString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Button to save the new item
                Button("Save") {
                    // Make sure the text field is not empty
                    guard !newItemString.isEmpty else {
                        return
                    }
                    
                    // Add the new item to the grocery list
                    let newItem = GroceryListItem(title: newItemString, subtitle: "", date: Date())
                    groceryList.items.append(newItem)
                    context.insert(newItem)
                    
                    // Dismiss the keyboard after saving
                    UIApplication.shared.endEditing()

                    // Clear the text field
                    newItemString = ""
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)

                // Main list showing the grocery items
                List {
                    // Items not yet purchased
                    Section("Not in Cart") {
                        ForEach(toBuyItems) { item in
                            HStack {
                                Image(systemName: item.inCart ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.inCart ? .green : .gray)
                                    .onTapGesture {
                                        withAnimation {
                                            item.inCart.toggle()
                                            try? context.save()
                                        }
                                    }

                                Text(item.title)
                                    .strikethrough(item.inCart)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let item = toBuyItems[index]
                                context.delete(item) // Delete item from context
                                
                                }
                            try? context.save() // Save changes
                            }
                    }

                    // Items already purchased
                    Section("In Cart") {
                        ForEach(boughtItems) { item in
                            HStack {
                                Image(systemName: item.inCart ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.inCart ? .green : .gray)
                                    .onTapGesture {
                                        withAnimation {
                                            item.inCart.toggle()
                                            try? context.save()
                                        }
                                    }

                                Text(item.title)
                                    .strikethrough(item.inCart)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let item = boughtItems[index]
                                context.delete(item) // Delete item from context
                                
                                }
                            try? context.save() // Save changes
                            }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .overlay {
                if items.isEmpty {
                    VStack {
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding()

                        Text("No Items Yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            .navigationTitle(groceryList.name) // <-- Use the list's actual name!
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Preview for Xcode canvas
#Preview {
    GroceryListDetailView(groceryList: ShoppingList(name: "Sample List"))
}

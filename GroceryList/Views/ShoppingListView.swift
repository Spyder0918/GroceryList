//
//  GroceryListsView.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 5/9/25.
//
import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Environment(\.modelContext) var context
    @Query var shoppinglists: [ShoppingList] // <-- list of lists

    @State private var newListName = ""
    @State private var refreshLists = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("New Shopping List Name", text: $newListName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Add New Shopping List") {
                    guard !newListName.isEmpty else { return }
                    let newList = ShoppingList(name: newListName)
                    context.insert(newList)
                    print("New list added: \(newList.name)") // Debugging
                    
                    do {
                            try context.save() // Save the context to persist the changes
                            print("Context saved successfully") // Debugging
                            refreshLists.toggle() // Force the view to refresh by toggling the state variable
                        } catch {
                            print("Failed to save context: \(error.localizedDescription)") // Debugging in case of an error
                        }
                    
                    newListName = ""
                    // Print current shopping lists to debug
                    print("Current shopping lists: \(shoppinglists.map { $0.name })")
                }
                .padding()

                List {
                    ForEach(shoppinglists) { list in
                        NavigationLink(destination: GroceryListDetailView(groceryList: list)) {
                            Text(list.name)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            context.delete(shoppinglists[index])
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Shopping Lists")
        }
    }
}

#Preview {
    ShoppingListView()
}

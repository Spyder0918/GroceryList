//
//  ContentView.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 3/30/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @State var newItemString = ""
    
    @Query var items: [GroceryListItem]
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Add item", text: $newItemString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save") {
                    guard !newItemString.isEmpty else {
                        return
                    }
                    
                    let newItem = GroceryListItem(title: newItemString, subtitle: "", date: Date())
                    
                    context.insert(newItem)
                    
                    newItemString = ""
                    
                }
                List {
                    ForEach(items) { item in
                        Text(item.title)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach ({index in
                            context.delete(items[index])
                        })
                        
                    }
                }
                .overlay {
                    if items.isEmpty {
                        Text("No Items")
                    }
                }
            }
            .navigationTitle("Grocery List")
                
            }
            
                
        }
    }


#Preview {
    ContentView()
}

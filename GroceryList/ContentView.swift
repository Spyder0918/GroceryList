//
//  ContentView.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 3/30/25.
//

import Foundation
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var context
    @State var newItemString = ""

    @Query var items: [GroceryListItem]

    var toBuyItems: [GroceryListItem] {
        items.filter { !$0.isPurchased }
    }

    var boughtItems: [GroceryListItem] {
        items.filter { $0.isPurchased }
    }

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
                    Section("To Buy") {
                        ForEach(toBuyItems) { item in
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
                            indexSet.forEach { index in
                                context.delete(toBuyItems[index])
                            }
                        }
                    }

                    Section("Bought") {
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
                            indexSet.forEach { index in
                                context.delete(boughtItems[index])
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)

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

//    #Preview {
//        ContentView()
//    }

//
//  GroceryListItem.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 3/30/25.
//

import Foundation
import SwiftData

@Model
public class GroceryListItem {
    public var title: String
    public var subtitle: String
    public var date: Date
    public var isPurchased: Bool

    public init(title: String, subtitle: String, date: Date, isPurchased: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.isPurchased = isPurchased
    }
}

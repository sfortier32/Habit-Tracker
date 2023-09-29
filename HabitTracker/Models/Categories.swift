//
//  Categories.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftData
import Foundation

@Model
class Category {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    @Relationship var habits: [Habit] = []
}

@Model
class Categories {
    var categories: [Category]
    
    init() {
        self.categories = []
    }
    
}

//
//  Categories.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftUI
import SwiftData

@Model
class Category {
    
    var orderIndex: Int
    var habits: [Habit]
    var title: String
    
    init(title: String, orderIndex: Int) {
        self.habits = []
        self.title = title
        self.orderIndex = orderIndex
    }
}

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

struct CategoryHeader: View {
    var title: String
    var cond: Bool
    init(_ title: String, cond: Bool) {
        self.title = title
        self.cond = cond
    }
    var body: some View {
        if cond {
            Text(title)
                .cust(20, true)
                .leading()
                .foregroundColor(.blck.opacity(0.9))
                .padding([.top, .horizontal])
        }
    }
}

extension Category {
    static var None: Category {
        .init(title: "None", orderIndex: 0)
    }
}

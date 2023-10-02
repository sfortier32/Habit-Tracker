//
//  TabModel.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/3/23.
//

import SwiftUI

class HabitInteractions: ObservableObject {
    @Published var editHabit: Bool
    @Published var openTimer: Bool
    @Published var habit: Habit
    
    init() {
        self.editHabit = false
        self.openTimer = false
        self.habit = Habit(title: "", weekDays: [], freqType: "", frequency: 0, imageName: "pills")
    }
}


func getNilHabit() -> Habit {
    return Habit(title: "", weekDays: [], freqType: "", frequency: 0, imageName: "pills")
}

class TabModel: ObservableObject {
    
    @Published var selected: Tab = .home
    
    enum Tab: String, CaseIterable {
        case home = "house"
        case stats = "chart.bar"
        case settings = "gearshape"
    }
}

//
//  Timer.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/27/23.
//

import SwiftData
import Foundation

@Model
class TimerModel {
    var habit: Habit
    var date: Date
    var secElapsed: Int = 0
    var secRemaining: Int
    
    init(habit: Habit, date: Date) {
        self.habit = habit
        self.date = date
        self.secRemaining = Int(habit.frequency * 60)
    }
}

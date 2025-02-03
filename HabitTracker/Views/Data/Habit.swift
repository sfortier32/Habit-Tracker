//
//  Habit.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/4/23.
//

import SwiftUI
import SwiftData

class HabitInteractions: ObservableObject {
    @Published var openHabitView: Bool
    @Published var openTimer: Bool
    @Published var habit: Habit
    @Published var duplicateHabit: Bool
    
    init() {
        self.openHabitView = false
        self.openTimer = false
        self.habit = Habit(title: "", weekdays: [], freqType: "", frequency: 0, imageName: "pills")
        self.duplicateHabit = false
    }
}

@Model
class Habit {
    var title: String
    var weekdays: [String]
    var freqType: String
    var frequency: Double
    
    var dateAdded: Date = Date.now.removeTimeStamp
    var firstOccurence: Date
    
    var notDone: [Date] = []
    var missed: [Date] = []
    var skipped: [Date] = []
    var done: [Date] = []
    var allTypesDone: [Date] = []
    
    var imageName: String
    var streak: Int = 0
    var category: Category?
    var categoryIndex: Int
    var timers: [Date:Int] = [:]
    var minutes: Int = 0
    
    var mergeWith: Habit? = nil
    
    init(title: String, weekdays: [String], freqType: String, frequency: Double, imageName: String, category: Category) {
        self.title = title
        self.weekdays = weekdays
        self.freqType = freqType
        self.frequency = frequency
        self.firstOccurence = DateModel().getFirstOccurence(date: Date().removeTimeStamp, occurences: weekdays)
        self.imageName = imageName
        self.category = category
        self.categoryIndex = category.orderIndex
        
        for day in DateModel().getDateCarousel() {
            let dy = day.removeTimeStamp
            self.notDone.append(dy)
        }
    }
    init(title: String, weekdays: [String], freqType: String, frequency: Double, imageName: String) {
        self.title = title
        self.weekdays = weekdays
        self.freqType = freqType
        self.frequency = frequency
        self.firstOccurence = DateModel().getFirstOccurence(date: Date().removeTimeStamp, occurences: weekdays)
        self.imageName = imageName
        self.category = nil
        self.categoryIndex = Int.max
        
        for day in DateModel().getDateCarousel() {
            let dy = day.removeTimeStamp
            self.notDone.append(dy)
        }
    }
}

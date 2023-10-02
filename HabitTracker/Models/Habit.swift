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
    
    init() {
        self.openHabitView = false
        self.openTimer = false
        self.habit = Habit(title: "", weekDays: [], freqType: "", frequency: 0, imageName: "pills")
    }
}

@Model
class Habit {
    var title: String
    var weekDays: [String]
    var freqType: String
    var frequency: Double
    
    var dateAdded: Date
    var firstOccurence: Date
    
    var notDone: [Date] = []
    var missed: [Date] = []
    var skipped: [Date] = []
    var done: [Date] = []
    var allTypesDone: [Date] = []
    
    var imageName: String
    var streak: Int = 0
    
    @Relationship(inverse: \Category.habits) var categories: [Category] = []
    
    init(title: String, weekDays: [String], freqType: String, frequency: Double, imageName: String) {
        self.title = title
        self.weekDays = weekDays
        self.freqType = freqType
        self.frequency = frequency
        
        self.dateAdded = Date().removeTimeStamp
        self.firstOccurence = DateModel().getFirstOccurence(date: Date().removeTimeStamp, occurences: weekDays)
        
        self.imageName = imageName
        
        for day in DateModel().getDateCarousel() {
            let dy = day.removeTimeStamp
            self.notDone.append(dy)
        }
    }
}

//
//  Achievements.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/27/23.
//

import SwiftUI
import SwiftData

@Model
class Achievements {
    var newUnlocked: Bool = false
    var newUnlockedNames: [String:Bool] = [:]
    
    var streaks: [String:Bool] = [
        "streaks_ach1_7":false,
        "streaks_ach2_14":false,
        "streaks_ach3_30":false,
        "streaks_ach4_90":false,
        "streaks_ach5_182":false,
        "streaks_ach6_365":false
    ]
    var tasks: [String:Bool] = [
        "tasks_ach1_10":false,
        "tasks_ach2_25":false,
        "tasks_ach3_50":false,
        "tasks_ach4_100":false,
        "tasks_ach5_250":false,
        "tasks_ach6_500":false,
        "tasks_ach7_1000":false
    ]
    
    
    var streakNames: [String:String] = [
        "streaks_ach1_7": "7 days",
        "streaks_ach2_14": "2 weeks",
        "streaks_ach3_30": "1 month",
        "streaks_ach4_90": "3 months",
        "streaks_ach5_182": "6 months",
        "streaks_ach6_365": "1 year"
        
    ]
    
    var taskNames: [String:String] = [
        "tasks_ach1_10": "10 tasks",
        "tasks_ach2_25": "25 tasks",
        "tasks_ach3_50": "50 tasks",
        "tasks_ach4_100": "100 tasks",
        "tasks_ach5_250": "250 tasks",
        "tasks_ach6_500": "500 tasks",
        "tasks_ach7_1000": "1000 tasks"
    ]
    
    var tasksCompleted: Int = 0
    
    init() {
    }
    
    func getComplete(_ arr: [String:Bool]) -> Text {
        return Text("\(arr.lazy.filter { $0.value == true }.count) / \(arr.count) Complete")
    }
}

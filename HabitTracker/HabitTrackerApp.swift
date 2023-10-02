//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/3/23.
//

import SwiftUI
import SwiftData

@main
struct Habit_TrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            Achievements.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @AppStorage("nameEntered") var nameEntered: Bool = false
    @AppStorage("name") var name: String = "You"
    @AppStorage("today") var today: String = {
        let fm = DateFormatter()
        fm.dateFormat = "MM-dd-YYYY"
        return fm.string(from: Date.now.removeTimeStamp)
    }()
    @AppStorage("bigStreaks") var bigStreaks: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if !nameEntered {
                TermsView()
            } else {
                ViewController()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

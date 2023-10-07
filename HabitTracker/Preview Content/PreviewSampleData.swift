//
//  PreviewSampleData.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/5/23.
//

import SwiftUI
import SwiftData

/// An actor that provides an in-memory model container for previews.
actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([
            Habit.self,
            Category.self,
            Achievements.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Habit.one,
            Habit.two,
            Habit.three,
            Achievements.test
        ]
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
}

// Default quakes for use in previews.
extension Habit {
    static var one: Habit {
        .init(title: "Water the plants", weekdays: ["Su", "Th"], freqType: "times", frequency: 1, imageName: "leaf")
    }
    static var two: Habit {
        .init(title: "Read", weekdays: ["Su", "Tu", "We", "Th"], freqType: "minutes", frequency: 30, imageName: "mouth", category: Category.afternoon)
    }
    static var three: Habit {
        .init(title: "Drink water", weekdays: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], freqType: "oz", frequency: 40, imageName: "waterbottle")
    }
}


extension Category {
    static var afternoon: Category {
        .init(title: "Afternoon", orderIndex: 0)
    }
    static var evening: Category {
        .init(title: "Evening", orderIndex: 1)
    }
}
extension Achievements {
    static var test: Achievements {
        .init()
    }
}

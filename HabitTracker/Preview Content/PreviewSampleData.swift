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
            Categories.self,
            Category.self,
            Habit.self,
            Achievements.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Habit.min,
            Habit.oneTime,
            Habit.otherUnit,
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
    static var oneTime: Habit {
        .init(title: "Water the plants", weekDays: ["Mo", "Tu", "We", "Th"], freqType: "times", frequency: 1, imageName: "leaf")
    }
    static var min: Habit {
        .init(title: "Brush teeth", weekDays: ["Su", "Mo", "Tu", "We", "Th", "Fr"], freqType: "minutes", frequency: 2, imageName: "mouth")
    }
    static var otherUnit: Habit {
        .init(title: "Drink water", weekDays: ["Fr", "Sa"], freqType: "oz", frequency: 40, imageName: "waterbottle")
    }
}

extension Achievements {
    static var test: Achievements {
        .init()
    }
}

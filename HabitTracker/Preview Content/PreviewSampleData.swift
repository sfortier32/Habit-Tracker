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
            Habit.four,
        ]
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
}

// Default habits for use in previews.
extension Habit {
    static var one: Habit {
        .init(title: "Water the plants", weekdays: ["Su", "Th"], freqType: "times", frequency: 1, imageName: "leaf")
    }
    static var two: Habit {
        .init(title: "Brush teeth", weekdays: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], freqType: "minutes", frequency: 2, imageName: "mouth", category: Category.morning)
    }
    static var three: Habit {
        .init(title: "Read", weekdays: ["Su", "Tu", "We", "Th"], freqType: "pages", frequency: 30, imageName: "book", category: Category.evening)
    }
    static var four: Habit {
        .init(title: "Workout", weekdays: ["Tu"], freqType: "minutes", frequency: 30, imageName: "figure.run", category: Category.evening)
    }
}


extension Category {
    static var morning: Category {
        .init(title: "Morning", orderIndex: 0)
    }
    static var afternoon: Category {
        .init(title: "Afternoon", orderIndex: 1)
    }
    static var evening: Category {
        .init(title: "Evening", orderIndex: 2)
    }
}
extension Achievements {
    static var test: Achievements {
        .init()
    }
}

//
//  StreakMerge.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 2/2/25.
//

import SwiftUI
import SwiftData

class StreakInteractions: ObservableObject {
    @Published var selected: Habit?
    init(selected: Habit?) {
        if selected != nil {
            self.selected = selected
        } else {
            self.selected = nil
        }
    }
}

// MARK: CategoryView
struct StreakMerge: View {
    @Environment(\.modelContext) var mc
    @EnvironmentObject var sInt: StreakInteractions
    @EnvironmentObject var hInt: HabitInteractions
    
    var duplicated: Bool
    
    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()
            VStack {
                Text("Merge Streaks").header2().center()
                    .baselineOffset(-6)
                StreakList(duplicated: duplicated)
                    .environmentObject(sInt)
            }
        }
    }
}

// MARK: CategoryList
struct StreakList: View {
    @Environment(\.modelContext) var mc
    @EnvironmentObject var sInt: StreakInteractions
    @EnvironmentObject var hInt: HabitInteractions
    
    @Query(sort: \Habit.title) private var habits: [Habit]
    var duplicated: Bool
    
    var body: some View {
        if (habits.count > 0) {
            List {
                Button {
                    sInt.selected = nil
                } label: {
                    HStack {
                        Text("None")
                        Spacer()
                        if sInt.selected == nil {
                            Image(systemName: "checkmark")
                                .resize(w: 14, h: 14)
                                .bold().foregroundColor(Color.blck.opacity(0.8))
                        }
                    }
                }.customListButton
                
                Text("Habits").customListHeader
                    .padding(.top, 7)
                ForEach(habits) { hb in
                    if (duplicated || hb != hInt.habit) {
                        Button {
                            sInt.selected = hb
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(hb.title)
                                    if (hb.category != nil) {
                                        Text(hb.category?.title ?? "").text3()
                                            .foregroundColor(.darkgray)
                                    }
                                }.leading()
                                Spacer()
                                if sInt.selected == hb {
                                    Image(systemName: "checkmark")
                                        .resize(w: 14, h: 14)
                                        .bold().foregroundColor(Color.blck.opacity(0.8))
                                }
                            }
                        }.customListButton
                    }
                }
            }.customListStyle
        } else {
            VStack {
                Spacer()
                Spacer()
                Text("You haven't created any other habits!").header2()
                    .foregroundColor(.blck)
                    .multilineTextAlignment(.center)
                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    StreakMerge(duplicated: false)
        .environmentObject(StreakInteractions(selected: nil))
        .environmentObject(HabitInteractions())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}

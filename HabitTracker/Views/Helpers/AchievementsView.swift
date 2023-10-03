//
//  AchievementsView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 10/2/23.
//

import SwiftUI
import SwiftData

struct AchievementsView: View {
    @State var count = 0
    @State var confettiVisible = true
    
//    @EnvironmentObject var tm: TabModel
    @Query var ach: [Achievements]
    @Query var habits: [Habit]
    
    // MARK: BODY
    var body: some View {
        ZStack {
            if ach[0].newUnlocked == true {
                ForEach(Array(ach[0].newUnlockedNames.keys), id: \.self) { key in
                    if ach[0].newUnlockedNames[key] == false {
                        NewBadgePopUp(name: key)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.35)) {
                                    count += 1
                                    ach[0].newUnlockedNames[key] = true
                                }
                            }.zIndex(Double(Array(ach[0].newUnlockedNames.keys).firstIndex(where: { $0 == key })!) + 1.0)
                    }
                }
                if count == ach[0].newUnlockedNames.keys.count {
                    let _ = resetValues()
                }
            } else {
                AnyView(Achievements).zIndex(0).transition(.slide)
            }
        }.onAppear(perform: {
            self.calculateTasksCompleted()
            self.calculateUnlocks()
        })
    }
    
    var Achievements: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Achievements").header1().padding(.top, 24)
                    Spacer()
                }.padding([.top, .horizontal])
                    .padding(.bottom, 4)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Streaks").header4().padding(.leading).padding(.top, 5)
                            Spacer().frame(width: 20)
                            ach[0].getComplete(ach[0].streaks).text3().foregroundColor(.darkgray).baselineOffset(-5)
                        }
                        BadgeListView(badges: ach[0].streaks)
                        
                        HStack {
                            Text("Tasks").header4().padding(.leading)
                            Spacer().frame(width: 20)
                            ach[0].getComplete(ach[0].tasks).text3().foregroundColor(.darkgray).baselineOffset(-5)
                        }
                        BadgeListView(badges: ach[0].tasks)
                    }.padding(.bottom, 12)
                }
                
                Spacer()
                TabsView()
//                    .environmentObject(tm)
            }
        }
    }
    func resetValues() -> Void {
        ach[0].newUnlocked = false
        ach[0].newUnlockedNames = [:]
    }
    func calculateTasksCompleted() -> Void {
        var tasks = 0
        for hb in habits {
            tasks += hb.allTypesDone.count
        }
        ach[0].tasksCompleted = tasks
    }
    func calculateUnlocks() -> Void { // TODO: Fix return
        // get max streak and check if meets threshold
        var maxStreak = 0
        for hb in habits { // calculate max streak
            maxStreak = max(maxStreak, hb.streak)
        }
        
        
        // determined which streak badges have been received
        var i = 1
        for badge in [7, 14, 30, 90, 182, 365] {
            if maxStreak >= badge {
                let name = "streaks_ach\(String(i))_\(String(badge))" // get name of reward
                if ach[0].streaks[name] == false {
                    ach[0].streaks[name] = true
                    ach[0].newUnlocked = true
                    ach[0].newUnlockedNames[name] = false
                }
            }
            i += 1
        }
        
        // determined which task badges have been received
        i = 1
        for badge in [10, 25, 50, 100, 250, 500, 1000] {
            if ach[0].tasksCompleted >= badge {
                let name = "tasks_ach\(String(i))_\(String(badge))" // get name of reward
                if ach[0].tasks[name] == false {
                    ach[0].tasks[name] = true
                    ach[0].newUnlocked = true
                    ach[0].newUnlockedNames[name] = false
                }
            }
            i += 1
        }
    }
}

#Preview {
    AchievementsView()
        .environmentObject(TabModel())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}

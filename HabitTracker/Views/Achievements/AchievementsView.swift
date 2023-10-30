//
//  AchievementsView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 10/2/23.
//

import SwiftUI
import SwiftData

struct NewBadgePopUp: View {
    @State var name: String
    @State var confettiVisible = true
    
    @Environment(\.modelContext) var mc
    @Query var ach: [Achievements]
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            VStack {
                Spacer()
                if name.starts(with: "streaks") {
                    Text("You have held a\nstreak for \(ach[0].streakNames[name]!)!")
                        .header1()
                        .center()
                } else if name.starts(with: "tasks") {
                    Text("You have completed \(ach[0].taskNames[name]!)!")
                        .header1()
                        .center()
                } else {
                    Text("You've worked at habits for \(ach[0].minuteNames[name]!)!")
                        .header1()
                        .center()
                }
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .shadow(color: .yellow.opacity(0.6), radius: 40, x: 0, y: 0)
                Spacer()
                Text("Tap to continue").text1().foregroundColor(.darkgray)
            }.padding()
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
              confettiVisible = false
            }
        })
        .withConfetti(isVisible: $confettiVisible)
    }
}


struct AchievementsView: View {
    @State var count = 0
    @State var confettiVisible = true
    
    @Query var ach: [Achievements]
    @Query var habits: [Habit]
    @EnvironmentObject var tm: TabModel
    
    // MARK: Body
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
                if count == ach[0].newUnlockedNames.keys.count || ach[0].newUnlockedNames.values.allSatisfy({$0}) {
                    let _ = resetValues()
                }
            } else {
                AnyView(Achievements).zIndex(0).transition(.slide)
            }
        }.onAppear(perform: {
            self.calculateCompleted()
            self.calculateUnlocks()
        })
    }
    
    // MARK: Achievements
    var Achievements: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            VStack {
                // MARK: Header
                HStack {
                    Text("Achievements")
                        .header1()
                        .padding(.top, 24)
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 4)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        // MARK: Streaks
                        HStack {
                            Text("Streaks")
                                .header4()
                                .padding(.leading)
                                .padding(.top, 5)
                            HSpacer(20)
                            ach[0].getComplete(ach[0].streaks).text3().foregroundColor(.darkgray).baselineOffset(-5)
                        }
                        .padding(.top, 10)
                        BadgeListView(badges: ach[0].streaks)
                        
                        // MARK: Tasks
                        HStack {
                            Text("Tasks")
                                .header4()
                                .padding(.leading)
                            HSpacer(20)
                            ach[0].getComplete(ach[0].tasks)
                                .text3()
                                .foregroundColor(.darkgray)
                                .baselineOffset(-5)
                        }
                        .padding(.top, 20)
                        BadgeListView(badges: ach[0].tasks)
                        
                        // MARK: Tasks
                        HStack {
                            Text("Minutes")
                                .header4()
                                .padding(.leading)
                            HSpacer(20)
                            ach[0].getComplete(ach[0].minutes)
                                .text3()
                                .foregroundColor(.darkgray)
                                .baselineOffset(-5)
                        }
                        .padding(.top, 20)
                        BadgeListView(badges: ach[0].minutes)
                        
                    }
                    .padding(.bottom, 12)
                }
                
                Spacer()
                TabsView()
                    .environmentObject(tm)
            }
        }
    }
    func resetValues() -> Void {
        ach[0].newUnlocked = false
        ach[0].newUnlockedNames = [:]
    }
    func calculateCompleted() -> Void {
        var tasks = 0
        for hb in habits {
            tasks += hb.allTypesDone.count
        }
        ach[0].tasksCompleted = tasks
        
        var minutes = 0
        for hb in habits {
            if hb.freqType == "minutes" {
                minutes += Int(hb.done.count) * Int(hb.frequency)
            }
        }
        ach[0].minutesCompleted = minutes
    }
    func calculateUnlocks() -> Void { // TODO: Fix return
        // get max streak and check if meets threshold
        var maxStreak = 0
        for hb in habits { // calculate max streak
            maxStreak = max(maxStreak, hb.streak)
        }
        
        
        // determine which streak badges have been received
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
        
        // determine which task badges have been received
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
        
        // determine which minute badges have been receieved
        i = 1
        for badge in [30, 60, 300, 720, 1440] {
            if ach[0].minutesCompleted >= badge {
                let name = "minutes_ach\(String(i))_\(String(badge))" // get name of reward
                if ach[0].minutes[name] == false {
                    ach[0].minutes[name] = true
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

//
//  StatsView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/1/23.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \Habit.title) var habits: [Habit]
    @Query var ach: [Achievements]
    
    @EnvironmentObject var tm: TabModel
    @Environment (\.modelContext) var mc
    
    @State var count = 0
    @State var confettiVisible = true
    
    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    
    
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
                AnyView(Settings).zIndex(0).transition(.slide)
            }
        }
    }
    
    // MARK: SETTINGS
    var Settings: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Statistics").header1().padding(.top, 24)
                    Spacer()
                }.padding([.top, .horizontal])
                    .padding(.bottom, 4)
                
                ScrollView {
                    // MARK: Streaks
                    VStack {
                        HStack {
                            Text("Streaks").header2()
                            Spacer()
                        }.padding(.horizontal)
                            .padding(.top, 12)
                    }
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(habits) { hb in
                            Rectangle()
                                .fill(Color.background)
                                .frame(height: UIScreen.main.bounds.width/2.5)
                                .cornerRadius(10)
                                .overlay {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("\(hb.streak)")
                                                    .font(.custom("FoundersGrotesk-Medium", size: 32))
                                                    .foregroundColor(Color("c-black"))
                                                Spacer()
                                                Image(systemName: hb.imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 25, height: 25)
                                            } // end hstack
                                            Spacer()
                                            Text("\(hb.title)").text1()
                                                .foregroundColor(.blck)
                                        } // end vstack
                                        Spacer()
                                    }.padding(.all, 18) // end hstack
                                }
                        }
                    }.padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Achievements").header2()
                                .padding(.leading)
                                .padding(.top, 25)
                            Spacer()
                        }
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
                    .mask(
                        VStack(spacing: 0) {
                            // Top gradient
                            LinearGradient(gradient:
                               Gradient(
                                   colors: [Color.black.opacity(0), Color.black]),
                                   startPoint: .top, endPoint: .bottom
                               )
                               .frame(height: 10)

                            // Middle
                            Rectangle().fill(Color.black)

                            // Bottom gradient
                            LinearGradient(gradient:
                               Gradient(
                                   colors: [Color.black, Color.black.opacity(0)]),
                                   startPoint: .top, endPoint: .bottom
                               )
                               .frame(height: 10)
                        }
                     )
                
                
                TabsView()
                    .environmentObject(tm)
            }
        }.onAppear(perform: {
            self.calculateStreaksTasksCompleted()
            self.calculateUnlocks()
        })
    }
    func resetValues() -> Void {
        ach[0].newUnlocked = false
        ach[0].newUnlockedNames = [:]
    }
    func calculateStreaksTasksCompleted() -> Void {
        var tasks = 0
        for hb in habits {
            if let last = hb.missed.last {
                hb.streak = hb.allTypesDone.lazy.filter{ $0 > last }.count
            } else {
                hb.streak = hb.allTypesDone.count
            }
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
    StatsView()
        .environmentObject(TabModel())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Achievements.self], inMemory: true)
}

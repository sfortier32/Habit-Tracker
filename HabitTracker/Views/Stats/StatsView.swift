//
//  StatsView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/1/23.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    
    @Query(sort: [SortDescriptor(\Habit.title), SortDescriptor(\Habit.categoryIndex)]) var habits: [Habit]
    @EnvironmentObject var tm: TabModel
    @EnvironmentObject var dm: DateModel
    @Environment(\.modelContext) var mc
    
    @State var bigStreaks = UserDefaults.standard.bool(forKey: "bigStreaks")
    @State var bigWeekly = UserDefaults.standard.bool(forKey: "bigWeekly")
    let bigCols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    let smallCols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12),
                     GridItem(.flexible(), spacing: 12)]
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Statistics").header1().padding(.top, 24)
                    .padding([.top, .horizontal])
                    .padding(.bottom, 4)
                
                ScrollView(showsIndicators: false) {
                    // MARK: Streaks
                    HStack {
                        Text("Streaks").header2().leading()
                            .baselineOffset(-8)
                        Button {
                            bigStreaks.toggle()
                        } label: {
                            Image(systemName: bigStreaks ? "arrow.down.left.square" : "arrow.up.right.square")
                                .resize(h: 24)
                        }
                    }.padding(.top, 4)
                    
                    if bigStreaks {
                        LazyVGrid(columns: bigCols, spacing: 12) {
                            ForEach(habits) { hb in
                                if (hb.mergeWith != nil) {
                                    if (hb.categoryIndex < hb.mergeWith?.categoryIndex ?? Int.max) {
                                        BigStreak(hb: hb, showCateg: false, streak: min(hb.streak, hb.mergeWith?.streak ?? 0))
                                    }
                                } else {
                                    BigStreak(hb: hb, showCateg: true, streak: hb.streak)
                                }
                            }
                        }
                    } else {
                        LazyVGrid(columns: smallCols, spacing: 12) {
                            ForEach(habits) { hb in
                                if (hb.mergeWith != nil) {
                                    if (hb.categoryIndex < hb.mergeWith?.categoryIndex ?? Int.max) {
                                        SmallStreak(hb: hb, streak: min(hb.streak, hb.mergeWith?.streak ?? 0))
                                    }
                                } else {
                                    SmallStreak(hb: hb, streak: hb.streak)
                                }
                            }
                        }
                    }
                    Spacer().frame(height: 30)
                    
                    // MARK: Weekly
                    HStack {
                        Text("Weekly").header2().leading()
                        Button {
                            bigWeekly.toggle()
                        } label: {
                            Image(systemName: bigWeekly ? "arrow.down.left.square" : "arrow.up.right.square")
                                .resize(h: 24)
                        }
                    }
                    
                    VStack(spacing: 14) {
                        ForEach(habits) { hb in
                            if (hb.mergeWith != nil) {
                                if (hb.categoryIndex < hb.mergeWith?.categoryIndex ?? Int.max) {
                                    HStack {
                                        if (bigWeekly) {
                                            BigWeeklyHeader(hb: hb, showCateg: false)
                                        } else {
                                            SmallWeeklyHeader(hb: hb)
                                        }
                                        Divider().padding(.horizontal, 5)
                                        WeeklyView(dm: dm, hb: hb)
                                    }
                                    .padding()
                                    .background(Color.background)
                                    .cornerRadius(10)
                                    .clipped()
                                    .frame(minHeight: 80)
                                }
                            } else {
                                HStack {
                                    if (bigWeekly) {
                                        BigWeeklyHeader(hb: hb, showCateg: true)
                                    } else {
                                        SmallWeeklyHeader(hb: hb)
                                    }
                                    Divider().padding(.horizontal, 5)
                                    WeeklyView(dm: dm, hb: hb)
                                }
                                .padding()
                                .background(Color.background)
                                .cornerRadius(10)
                                .clipped()
                                .frame(minHeight: 80)
                            }
                        }
                    }
                    .padding(.bottom, 15)
                }
                .VMask()
                .foregroundColor(.blck)
                .padding(.horizontal)
                
                
                TabsView()
                    .environmentObject(tm)
            }
        }.onAppear(perform: {
            self.calculateStreaks()
        })
        .onDisappear(perform: {
            UserDefaults.standard.set(bigStreaks, forKey: "bigStreaks")
            UserDefaults.standard.set(bigWeekly, forKey: "bigWeekly")
        })
    }
    func calculateStreaks() -> Void {
        for hb in habits {
            if let last = hb.missed.last {
                hb.streak = hb.allTypesDone.lazy.filter{ $0 > last && !hb.skipped.contains($0) }.count
            } else {
                hb.streak = hb.allTypesDone.lazy.filter{ !hb.skipped.contains($0) }.count
            }
        }
    }
}

#Preview {
    StatsView()
        .environmentObject(TabModel())
        .environmentObject(DateModel())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}

struct BigStreak: View {
    var hb: Habit
    var showCateg: Bool
    var streak: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.background)
            .frame(height: UIScreen.main.bounds.width/2.8)
            .cornerRadius(10)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(streak)").cust(32, true)
                                .baselineOffset(-10)
                            Spacer()
                            Image(systemName: hb.imageName)
                                .resize(w: 24, h: 24)
                        } // end hstack
                        .padding(.top, -5)
                        
                        Spacer()
                        if (showCateg) {
                            Text("\(hb.category?.title ?? "")").text3()
                                .foregroundColor(.darkgray)
                                .padding(.bottom, -4)
                        } else {
                            Text("")
                        }
                        Text("\(hb.title)").text1()
                    } // end vstack
                    Spacer()
                }.padding(.all, 18) // end hstack
            }
    }
}

struct SmallStreak: View {
    var hb: Habit
    var streak: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.background)
            .frame(height: UIScreen.main.bounds.width/7)
            .cornerRadius(10)
            .overlay {
                HStack {
                    Text("\(streak)").cust(30, true)
                        .baselineOffset(-10)
                    Spacer().frame(width: 20)
                    Image(systemName: hb.imageName)
                        .resize(w: 24, h: 24)
                } // end hstack
                .padding(.all, 18)
            }
    }
}

struct BigWeeklyHeader: View {
    var hb: Habit
    var showCateg: Bool
    
    var body: some View {
        VStack {
            if (hb.category != nil && showCateg) {
                Text(hb.category?.title ?? "").text4().leading()
                    .foregroundColor(.darkgray)
                    
            }
            Text(hb.title).leading().text3()
                .lineLimit(2)
        }
        .frame(width: 70)
    }
}

struct SmallWeeklyHeader: View {
    var hb: Habit
    
    var body: some View {
        Image(systemName: hb.imageName)
            .resize(w: 24, h: 24)
            .frame(width: 70)
    }
}


struct WeeklyView: View {
    var dm: DateModel
    var hb: Habit
    
    var body: some View {
        HStack {
            ForEach(dm.getThisWeek(), id: \.self) { date in
                let weekday = dm.getWeekday(date: date, short: true)
                HabitStack(habit: hb, date: date, weekday: weekday)
            }
        }
        .center()
    }
}

struct HabitStack: View {
    var habit: Habit
    var date: Date
    var weekday: String
    
    var body: some View {
        VStack {
            Text(weekday)
                .cust(14, true)
                .textCase(.uppercase)
                .padding(.bottom, -2)
            if (habit.mergeWith != nil) {
                let lcolor = self.getColor(hb: habit)
                let rcolor = self.getColor(hb: habit.mergeWith!)
                HalfColoredCircle(l: lcolor, r: rcolor)
            } else {
                let color = self.getColor(hb: habit)
                HalfColoredCircle(l: color, r: color)
            }
        }
        .frame(width: 26)
        .opacity(habit.weekdays.contains(weekday) ? 1 : 0.3)
    }
    func getColor(hb: Habit) -> Color {
        if (hb.done.contains(date)) {
            return Color.grn
        } else if (hb.notDone.contains(date)) {
            return Color.grayshadow
        } else if (hb.missed.contains(date)) {
            return Color.red
        } else {
            return Color.blue
        }
    }
}


struct HalfColoredCircle: View {
    var l: Color
    var r: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(l)
                .frame(width: 26, height: 26)
                .offset(x: -13)
            
            Rectangle()
                .fill(r)
                .frame(width: 26, height: 26)
                .offset(x: 13)
        }
        .frame(width: 26, height: 26)
        .clipShape(Circle())
        .rotationEffect(.degrees(45))
    }
}

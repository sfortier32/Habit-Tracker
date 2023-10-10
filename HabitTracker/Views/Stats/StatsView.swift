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
    @EnvironmentObject var tm: TabModel
    @EnvironmentObject var dm: DateModel
    @Environment (\.modelContext) var mc
    
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
                                Rectangle()
                                    .fill(Color.background)
                                    .frame(height: UIScreen.main.bounds.width/2.8)
                                    .cornerRadius(10)
                                    .overlay {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text("\(hb.streak)").cust(32, true)
                                                    Spacer()
                                                    Image(systemName: hb.imageName)
                                                        .resize(w: 24, h: 24)
                                                } // end hstack
                                                Spacer()
                                                Text("\(hb.category?.title ?? "")").text3()
                                                    .foregroundColor(.darkgray)
                                                    .padding(.bottom, -2)
                                                Text("\(hb.title)").text1()
                                            } // end vstack
                                            Spacer()
                                        }.padding(.all, 18) // end hstack
                                    }
                            }
                        }
                    } else {
                        LazyVGrid(columns: smallCols, spacing: 12) {
                            ForEach(habits) { hb in
                                Rectangle()
                                    .fill(Color.background)
                                    .frame(height: UIScreen.main.bounds.width/7)
                                    .cornerRadius(10)
                                    .overlay {
                                        HStack {
                                            Text("\(hb.streak)").cust(30, true)
                                                .baselineOffset(-10)
                                            Spacer().frame(width: 20)
                                            Image(systemName: hb.imageName)
                                                .resize(w: 24, h: 24)
                                        } // end hstack
                                        .padding(.all, 18)
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
                            HStack {
                                if bigWeekly {
                                    VStack {
                                        Spacer()
                                        if hb.category != nil {
                                            Text(hb.category!.title).text4().leading()
                                                .foregroundColor(.darkgray)
                                        }
                                        Text(hb.title).text2().leading()
                                    }
                                } else {
                                    Image(systemName: hb.imageName)
                                        .resize(w: 24, h: 24)
                                        .frame(width: 70)
                                }
                                Divider()
                                    .padding(.horizontal, 5)
                                HStack {
                                    ForEach(dm.getThisWeek(), id: \.self) { date in
                                        let weekday = dm.getWeekday(date: date, short: true)
                                        HabitStack(habit: hb, date: date, weekday: weekday, arr:
                                                    hb.done.contains(date) ? Completion.done :
                                                    hb.notDone.contains(date) ? Completion.notDone :
                                                    hb.missed.contains(date) ? Completion.missed :
                                                    Completion.skipped)
                                    }
                                }
                                .center()
                            }
                            .padding()
                            .background(Color.background)
                            .cornerRadius(10)
                            .clipped()
                        }
                        .frame(minHeight: 80)
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

struct HabitStack: View {
    var habit: Habit
    var date: Date
    var weekday: String
    var arr: Completion
    
    var body: some View {
        VStack {
            Text(weekday)
                .cust(14, true)
                .textCase(.uppercase)
                .padding(.bottom, -2)
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 26, height: 26)
                .foregroundColor(arr == .notDone ? .grayshadow : (
                        (arr == .done ? .grn :
                        (arr == .missed ? .red : .blue)))
                )
        }.frame(width: 26)
        .opacity(habit.weekdays.contains(weekday) ? 1 : 0.3)
    }
}

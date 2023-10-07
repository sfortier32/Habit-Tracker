//
//  HomeView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/3/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var mc
    @EnvironmentObject var tm: TabModel
    @EnvironmentObject var dm: DateModel
    
    @StateObject var hInt: HabitInteractions = HabitInteractions()
    
    @State var addHabit = false
    @State private var date = Date.now.removeTimeStamp
    @State private var dateSelected: Date = Date().removeTimeStamp
    @State private var selectedWeekday: String = DateModel().getWeekday(date: Date(), short: true)
    
    @Query var habits: [Habit]
    
    let fm = {
        let fm = DateFormatter()
        fm.dateFormat = "MM-dd-YYYY"
        return fm
    }()
    
    var body: some View {
        ZStack {
            Color("c-cream")
                .ignoresSafeArea()
            VStack {
                // MARK: Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hey, ").font(.custom("FoundersGrotesk-Regular", size: 40)) +
                        Text("\(UserDefaults.standard.string(forKey: "name") ?? "You")!").font(.custom("FoundersGrotesk-Medium", size: 40))
                    }
                    .baselineOffset(-12)
                    Spacer()
                    
                    Button {
                        addHabit.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resize(h: 20)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .padding(.top, 12)
                
                // MARK: Date Display
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(dm.getDateCarousel(), id: \.self) { date in
                            let day = dm.getDay(date: date)
                            let weekday = dm.getWeekday(date: date, short: true)
                            let cur = date.removeTimeStamp
                            
                            Button {
                                // MARK: Set new habits
                                selectedWeekday = weekday
                                dateSelected = cur
                            } label: {
                                DateView(cur, dateSelected, day, weekday)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                
                // MARK: Habit List
                HabitList(date: dateSelected, weekday: selectedWeekday, count: getCount())
                    .environmentObject(hInt)
                TabsView()
                    .environmentObject(tm)
                    .padding(.top, 15)
            }
        
        }.onAppear(perform: {
            if UserDefaults.standard.string(forKey: "today") != self.fm.string(from: date) {
                updateHabits()
            }
        })
        .sheet(isPresented: $hInt.openHabitView, content: {
            HabitView(editor: true, pageOpen: $hInt.openHabitView, habit: hInt.habit)
                .environmentObject(hInt)
        })
        .sheet(isPresented: $addHabit, content: {
            HabitView(editor: false, pageOpen: $addHabit, habit: nil)
                .environmentObject(hInt)
        })
        .sheet(isPresented: $hInt.openTimer, content: {
            TimerView(habit: hInt.habit, date: dateSelected)
                .environmentObject(hInt)
        })
    }
    
    // MARK: Functions
    func updateHabits() -> Void {
        for hb in habits {
            hb.notDone.sort() // sort data so break works
            for day in hb.notDone {
                if day < date { // if habit isn't done and past due
                    hb.notDone.removeAll(where: {$0 == day }) // remove from notDone
                    hb.missed.append(day) // append to missed
                } else {
                    break
                }
            }
            hb.notDone.append(getDateAhead(val: 6)) // add newest carousel date to not done
            
            hb.missed = hb.missed.sorted().reversed()
            for day in hb.missed {
                if day >= date || day < hb.dateAdded {
                    hb.missed.removeAll(where: { $0 == day }) // remove from missed
                    hb.notDone.append(day) // append to notDone
                }
            }
            hb.notDone.sort()
        }
    }
    func getCount() -> Int {
        var cnt = 0
        for hb in habits {
            if hb.dateAdded <= date && hb.weekdays.contains(selectedWeekday) {
                cnt += 1
            }
        }
        return cnt
    }
}

#Preview {
    HomeView()
        .environmentObject(TabModel())
        .environmentObject(DateModel())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}

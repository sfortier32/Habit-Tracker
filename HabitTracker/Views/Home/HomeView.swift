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
    @State private var selected: Date = Date().removeTimeStamp
    @State private var selectedWeekday: String = DateModel().getWeekday(date: Date(), short: true)
    @State private var currDate = Date.now.removeTimeStamp
    
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
                // MARK: Title
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hey, ").font(.custom("FoundersGrotesk-Regular", size: 40)) +
                        Text("\(UserDefaults.standard.string(forKey: "name") ?? "You")!").font(.custom("FoundersGrotesk-Medium", size: 40))
                    }.baselineOffset(-12)
                    Spacer()
                    
                    // MARK: Add Habit
                    Button {
                        addHabit.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resize(h: 20)
                            .padding(.horizontal)
                            .offset(y: -1)
                    }
                }.padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.vertical, 12)
                
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
                                selected = cur
                            } label: {
                                DateView(cur, selected, day, weekday)
                            }
                        }
                    }
                }.padding(.horizontal, 10)
                    .padding(.bottom, 5)
                
                // MARK: Habit List
                HabitList(date: selected, weekday: selectedWeekday, count: getCount())
                    .environmentObject(hInt)
                TabsView()
                    .environmentObject(tm)
            }
        }.onAppear(perform: {
            if UserDefaults.standard.string(forKey: "today") != self.fm.string(from: currDate) {
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
    }
    func updateHabits() -> Void {
        for hb in habits {
            hb.notDone.sort() // sort data so break works
            for day in hb.notDone {
                if day < currDate { // if habit isn't done and past due
                    hb.notDone.removeAll(where: {$0 == day }) // remove from notDone
                    hb.missed.append(day) // append to missed
                } else {
                    break
                }
            }
            hb.notDone.append(getDateAhead(val: 6)) // add newest carousel date to not done
            
            hb.missed = hb.missed.sorted().reversed()
            for day in hb.missed {
                if day >= currDate || day < hb.dateAdded {
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
            if hb.dateAdded <= currDate && hb.weekDays.contains(selectedWeekday) {
                cnt += 1
            }
        }
        return cnt
    }
}


// MARK: HabitList
struct HabitList: View {
    var weekday: String
    var date: Date
    var count: Int
    
    @State private var currDate = Date.now.removeTimeStamp
    @State private var deleteHabit: Bool = false
    @State private var habitToDelete: Habit? = nil
    
    @Environment(\.modelContext) private var mc
    @EnvironmentObject var hInt: HabitInteractions
    
    @Query var habitsWOCateg: [Habit]
    @Query(sort: \Category.orderIndex) var categs: [Category]

    init(
        date: Date,
        weekday: String,
        count: Int
    ) {
        self.weekday = weekday
        self.date = date
        self.count = count
        
        _habitsWOCateg = Query(
            filter: #Predicate<Habit> { hb in
                hb.category == nil
            },
            sort: \Habit.title,
            order: .forward
        )
    }
    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()
            
            // MARK: Habit Cards
            if count > 0 {
                ScrollView {
                    ForEach(habitsWOCateg, id: \.self) { hb in
                        HabitRow(hb: hb, date: date)
                        Text("Category: Uncategorized")
                    }.id(UUID())
                    ForEach(categs, id: \.self) { cg in
                        ForEach(cg.habits, id: \.self) { hb in
                            HabitRow(hb: hb, date: date)
                            Text("Category: \(cg.title)")
                        }.id(UUID())
                    }.id(UUID())
                }
//                List(0..<order.count, id: \.self) { key in
//                    let cgName = order[key]!
//                    let mer = merged[cgName]!.filter({ hb in
//                        hb.dateAdded <= date && hb.weekDays.contains(weekday)
//                    })
//                    if mer.count > 0 {
//                        Section {
//                            ForEach(mer, id: \.self) { hb in
//                                HabitRow(hb: hb, date: date)
//                                    .environmentObject(hInt)
//                                    .listStyle
//                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                                        Button(role: .destructive) {
//                                            habitToDelete = hb
//                                            deleteHabit.toggle()
//                                        } label: {
//                                            Image(systemName: "trash")
//                                        }
//                                    }
//                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                        Button() { // MARK: Done
//                                            if hb.done.contains(date) { // if marked as done
//                                                hb.done.removeAll(where: { $0 == date })
//                                                if date < currDate { // return to missed
//                                                    hb.missed.append(date)
//                                                    hb.missed.sort()
//                                                } else { // return to not done
//                                                    hb.notDone.append(date)
//                                                    hb.notDone.sort()
//                                                }
//                                                hb.allTypesDone.removeAll(where: { $0 == date })
//                                            } else {
//                                                hb.done.append(date)
//                                                hb.done.sort()
//                                                if hb.notDone.contains(date) { // notDone -> done
//                                                    hb.notDone.removeAll(where: { $0 == date })
//                                                    hb.allTypesDone.append(date)
//                                                    hb.allTypesDone.sort()
//                                                } else if hb.skipped.contains(date) { // skipped -> done
//                                                    hb.skipped.removeAll(where: { $0 == date })
//                                                } else { // in missed
//                                                    hb.missed.removeAll(where: { $0 == date }) // missed -> done
//                                                    hb.allTypesDone.append(date)
//                                                    hb.allTypesDone.sort()
//                                                }
//                                            }
//                                        } label: {
//                                            Label(
//                                                title: { Text("Done") },
//                                                icon: { Image(systemName: "checkmark") })
//                                        }.tint(.green)
//                                        
//                                        Button() { // MARK: Skip
//                                            if hb.skipped.contains(date) { // if marked as skipped
//                                                hb.skipped.removeAll(where: { $0 == date })
//                                                if date < currDate { // return to missed
//                                                    hb.missed.append(date)
//                                                    hb.missed.sort()
//                                                } else { // return to not done
//                                                    hb.notDone.append(date)
//                                                    hb.notDone.sort()
//                                                }
//                                                hb.allTypesDone.removeAll(where: { $0 == date })
//                                            } else {
//                                                hb.skipped.append(date)
//                                                hb.skipped.sort()
//                                                if hb.notDone.contains(date) { // notDone -> skipped
//                                                    hb.notDone.removeAll(where: { $0 == date })
//                                                    hb.allTypesDone.append(date)
//                                                    hb.allTypesDone.sort()
//                                                } else if hb.done.contains(date) { // done -> skipped
//                                                    hb.done.removeAll(where: { $0 == date })
//                                                } else { // missed -> skipped
//                                                    hb.missed.removeAll(where: { $0 == date })
//                                                    hb.allTypesDone.append(date)
//                                                    hb.allTypesDone.sort()
//                                                }
//                                            }
//                                        } label: {
//                                            Label(
//                                                title: { Text("Skip") },
//                                                icon: { Image(systemName: "arrow.uturn.left") })
//                                        }.tint(.blue)
//                                        
//                                    }
//                            }
//                        } header: {
//                            Text(cgName).textCase(nil)
//                        }
//                    }
//                }.id(UUID())
//                    .scrollContentBackground(.hidden)
//                    .listStyle(GroupedListStyle())
//                    .font(.custom("FoundersGrotesk-Regular", size: 20))
//                    .baselineOffset(-5)
//                    .listSectionSpacing(8)
                
            } else {
                VStack {
                    Spacer()
                    Spacer()
                    Text("No tasks today!").header2().foregroundColor(.blck)
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            
        }.font(.custom("FoundersGrotesk-Regular", size: 20))
    }
}

#Preview {
    HomeView()
        .environmentObject(TabModel())
        .environmentObject(DateModel())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}



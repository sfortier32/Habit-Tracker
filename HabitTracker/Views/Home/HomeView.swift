//
//  HomeView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/3/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var mc
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
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 21)
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
                HabitList(dte: selected, wkday: selectedWeekday, cnt: getCount())
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
        })
        .sheet(isPresented: $addHabit, content: {
            HabitView(editor: false, pageOpen: $addHabit, habit: nil)
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
        var count = 0
        for hb in habits {
            if hb.weekDays.contains(self.selectedWeekday) {
                count += 1
            }
        }
        return count
    }
}

#Preview {
    HomeView()
        .environmentObject(TabModel())
        .environmentObject(DateModel())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Achievements.self], inMemory: true)
}


struct DateView: View {
    var cur: Date
    var selected: Date
    var day: String
    var weekday: String
    
    @Query var habits: [Habit]
    @Environment(\.modelContext) private var mc

    init(
        _ current: Date,
        _ select: Date,
        _ dy: String,
        _ wkday: String
    ) {
        cur = current
        selected = select
        day = dy
        weekday = wkday
        
        _habits = Query(
            filter: #Predicate<Habit> {
                cur >= $0.dateAdded
            },
            sort: \Habit.title,
            order: .forward
        )
    }
    var body: some View {
        let count = getHabitsOn(selected)
        if cur != selected {
            if count == 0 {
                VStack(alignment: .center) {
                    Text(weekday).header5()
                        .foregroundColor(.gray)
                        .textCase(.uppercase)
                    Spacer()
                        .frame(height: 12)
                    Text(day)
                        .foregroundColor(.blck).header5()
                }.frame(width: 50, height: 90)
                    .cornerRadius(40)
            } else { // habits occur
                VStack(alignment: .center) {
                    Text(weekday).header5()
                        .foregroundColor(.gray)
                        .textCase(.uppercase)
                        .padding(.top, 2)
                        .padding(.bottom, -7)
                    RoundedRectangle(cornerRadius: 35)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.grayshadow)
                        .overlay {
                            Text(day)
                                .foregroundColor(.blck).header5()
                                .baselineOffset(-5)
                        }
                }.frame(width: 50, height: 85)
                    .cornerRadius(40)
                    .padding(.top, 5)
            }
        } else {
            VStack(alignment: .center) {
                Text(weekday).header5()
                    .foregroundColor(.cream)
                    .textCase(.uppercase)
                    .padding(.top, -1)
                    .padding(.bottom, 2)
                Spacer()
                    .frame(height: 10)
                Text(day)
                    .foregroundColor(.cream).header5()
            }.frame(width: 50, height: 90)
                .background(Color.blck)
                .cornerRadius(40)
        }
    }
    func getHabitsOn(_ date: Date) -> Int {
        if self.habits == [] { return 0 }
        var res: [Habit] = []
        for hb in self.habits {
            if hb.weekDays.contains(weekday) {
                res.append(hb)
            }
        }
        return res.count
    }
}

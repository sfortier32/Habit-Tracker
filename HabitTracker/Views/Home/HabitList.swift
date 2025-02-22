//
//  HabitListView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/13/23.
//

import SwiftUI
import SwiftData

struct HabitList: View {
    var weekday: String
    var date: Date
    var count: Int
    
    @State var deleteHabit: Bool = false
    @State var activeHabit: Habit? = nil
    
    @Environment(\.modelContext) private var mc
    @EnvironmentObject var hInt: HabitInteractions
    
    @Query var habitsWOCateg: [Habit]
    @Query(sort: \Category.orderIndex) var categs: [Category]
    
    init(date: Date, weekday: String, count: Int) {
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
            if count > 0 {
                AnyView(Page)
            } else {
                AnyView(EmptyPage)
            }
        }
    }
    var EmptyPage: some View {
        VStack {
            Spacer()
            Spacer()
            Text("No habits today!").header2().foregroundColor(.blck)
            Spacer()
            Spacer()
            Spacer()
        }
    }
    
    var Page: some View {
        VStack {
            List {
                ForEach(categs) { cg in
                    let chFiltered = cg.habits.filter({
                        $0.dateAdded <= date && $0.weekdays.contains(weekday)
                    })
                    if !chFiltered.isEmpty {
                        Text("\(cg.title)").customListHeader
                            .padding(.top, 7)
                        ForEach(chFiltered) { hb in
                            HabitRow(hb: hb, date: self.date, arr:
                                        hb.done.contains(date) ? Completion.done :
                                        hb.notDone.contains(date) ? Completion.notDone :
                                        hb.missed.contains(date) ? Completion.missed :
                                        Completion.skipped)
                            .customListButton
                            .customSwipeActions(hb: hb, date: date)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    activeHabit = hb
                                    deleteHabit.toggle()
                                } label: {
                                    Label(
                                        title: { Text("Delete") },
                                        icon: { Image(systemName: "trash") })
                                }
                                Button() { // duplicate
                                    activeHabit = hb
                                    hInt.habit = hb
                                    hInt.duplicateHabit = true
                                } label: {
                                    Label(
                                        title: { Text("Duplicate") },
                                        icon: { Image(systemName: "plus.square.on.square" )})
                                }.tint(.pink)
                            }
                        } // end foreach habits
                    } // end foreach categs
                } // end isEmpty
                
                let habitsWOFiltered = habitsWOCateg.filter({ $0.dateAdded <= date && $0.weekdays.contains(weekday) })
                if !habitsWOFiltered.isEmpty {
                    Text("Uncategorized").customListHeader
                    ForEach(habitsWOFiltered) { hb in
                        HabitRow(hb: hb, date: self.date, arr:
                                    hb.done.contains(date) ? Completion.done :
                                    hb.notDone.contains(date) ? Completion.notDone :
                                    hb.missed.contains(date) ? Completion.missed :
                                    Completion.skipped
                        )
                            .customListButton
                            .customSwipeActions(hb: hb, date: date)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    activeHabit = hb
                                    deleteHabit.toggle()
                                } label: {
                                    Label(
                                        title: { Text("Delete") },
                                        icon: { Image(systemName: "trash") })
                                }
                                Button() { // duplicate
//                                    activeHabit = hb
//                                    hInt.habit = activeHabit
//                                    hInt.duplicateHabit = true
                                } label: {
                                    Label(
                                        title: { Text("Duplicate") },
                                        icon: { Image(systemName: "plus.square.on.square" )})
                                }.tint(.pink)
                            }
                    } // end foreach
                } // end ifEmpty
            }
            .customListStyle // end list
            .VMask()
            
            .confirmationDialog("Are you sure you want to delete " + (activeHabit == nil ? "this habit?" : "\"\(activeHabit!.title)\"?"), isPresented: $deleteHabit, titleVisibility: .visible) {
                Button("Yes", role: .destructive) {
                    deleteHabit.toggle()
                    if let hb = activeHabit {
                        mc.delete(hb)
                    }
                    activeHabit = nil
                }
            }
            
        }.font(.custom("FoundersGrotesk-Regular", size: 20))
    }
}

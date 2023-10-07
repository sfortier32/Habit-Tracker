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
    @State var habitToDelete: Habit? = nil
    
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
                            .swipeThreeActions(hb: hb, date: date)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    habitToDelete = hb
                                    deleteHabit.toggle()
                                } label: {
                                    Image(systemName: "trash")
                                }
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
                            .swipeThreeActions(hb: hb, date: date)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    habitToDelete = hb
                                    deleteHabit.toggle()
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    } // end foreach
                } // end ifEmpty
            }
            .customListStyle // end list
            .VMask()
            
            .confirmationDialog("Are you sure you want to delete " + (habitToDelete == nil ? "this habit?" : "\"\(habitToDelete!.title)\"?"), isPresented: $deleteHabit, titleVisibility: .visible) {
                Button("Yes", role: .destructive) {
                    deleteHabit.toggle()
                    if let hb = habitToDelete {
                        mc.delete(hb)
                    }
                    habitToDelete = nil
                }
            }
            
        }.font(.custom("FoundersGrotesk-Regular", size: 20))
    }
}

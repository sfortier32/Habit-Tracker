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
    
    @State private var currDate = Date.now.removeTimeStamp
    @State private var deleteHabit: Bool = false
    @State private var habitToDelete: Habit? = nil
    
    @Query var habits: [Habit]
    @Environment(\.modelContext) private var mc
    @EnvironmentObject var hInt: HabitInteractions

    init(
        dte: Date,
        wkday: String,
        cnt: Int
    ) {
        weekday = wkday
        date = dte
        count = cnt
        
        _habits = Query(
            filter: #Predicate<Habit> {
                $0.dateAdded <= date
            },
            sort: \Habit.title,
            order: .forward
        )
    }
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            // MARK: Habit Cards
            if count > 0 {
                List(habits, id: \.self) { hb in
                    if hb.weekDays.contains(weekday) {
                        HabitRow(hb: hb, date: self.date)
                            .environmentObject(hInt)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color("c-background"))
                                    .padding([.leading, .trailing], 15)
                                    .padding([.top, .bottom], 8)
                            )
                            .padding(.all, 10)
                            .listRowSeparator(.hidden)
                        
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    habitToDelete = hb
                                    deleteHabit.toggle()
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button() { // MARK: Done
                                    if hb.done.contains(date) { // if marked as done
                                        hb.done.removeAll(where: { $0 == date })
                                        if date < currDate { // return to missed
                                            hb.missed.append(date)
                                            hb.missed.sort()
                                        } else { // return to not done
                                            hb.notDone.append(date)
                                            hb.notDone.sort()
                                        }
                                        hb.allTypesDone.removeAll(where: { $0 == date })
                                    } else {
                                        hb.done.append(date)
                                        hb.done.sort()
                                        if hb.notDone.contains(date) { // notDone -> done
                                            hb.notDone.removeAll(where: { $0 == date })
                                            hb.allTypesDone.append(date)
                                            hb.allTypesDone.sort()
                                        } else if hb.skipped.contains(date) { // skipped -> done
                                            hb.skipped.removeAll(where: { $0 == date })
                                        } else { // in missed
                                            hb.missed.removeAll(where: { $0 == date }) // missed -> done
                                            hb.allTypesDone.append(date)
                                            hb.allTypesDone.sort()
                                        }
                                    }
                                } label: {
                                    Label(
                                        title: { Text("Done") },
                                        icon: { Image(systemName: "checkmark") })
                                }.tint(.green)
//                                    .disabled(date > currDate)
                                
                                
                                Button() { // MARK: Skip
                                    if hb.skipped.contains(date) { // if marked as skipped
                                        hb.skipped.removeAll(where: { $0 == date })
                                        if date < currDate { // return to missed
                                            hb.missed.append(date)
                                            hb.missed.sort()
                                        } else { // return to not done
                                            hb.notDone.append(date)
                                            hb.notDone.sort()
                                        }
                                        hb.allTypesDone.removeAll(where: { $0 == date })
                                    } else {
                                        hb.skipped.append(date)
                                        hb.skipped.sort()
                                        if hb.notDone.contains(date) { // notDone -> skipped
                                            hb.notDone.removeAll(where: { $0 == date })
                                            hb.allTypesDone.append(date)
                                            hb.allTypesDone.sort()
                                        } else if hb.done.contains(date) { // done -> skipped
                                            hb.done.removeAll(where: { $0 == date })
                                        } else { // missed -> skipped
                                            hb.missed.removeAll(where: { $0 == date })
                                            hb.allTypesDone.append(date)
                                            hb.allTypesDone.sort()
                                        }
                                    }
                                } label: {
                                    Label(
                                        title: { Text("Skip") },
                                        icon: { Image(systemName: "arrow.uturn.left") })
                                }.tint(.blue)
//                                    .disabled(date > currDate)
                            }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                
                .confirmationDialog("Are you sure you want to delete " + (habitToDelete == nil ? "this habit?" : "\"\(habitToDelete!.title)\"?"), isPresented: $deleteHabit, titleVisibility: .visible) {
                    Button("Yes", role: .destructive) {
                        deleteHabit.toggle()
                        if let hb = habitToDelete {
                            mc.delete(hb)
                        }
                        habitToDelete = nil
                    }
                }
            } else {
                ZStack {
                    Color.cream
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                        Spacer()
                        Text("No habits today!").header2().foregroundColor(.blck)
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }.font(.custom("FoundersGrotesk-Regular", size: 20))
    }
}


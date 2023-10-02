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
    
    @StateObject var dm: DateModel = DateModel()
    @StateObject var hInt: HabitInteractions = HabitInteractions()
    
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
                    
                    // MARK: Edit Categories
                    Button {
                        
                    } label: {
                        Image(systemName: "list.dash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16)
                            .padding(.trailing, 8)
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
                                VStack(alignment: .center) {
                                    Text(weekday)
                                        .foregroundColor(cur != selected ? .gray : Color("c-cream"))
                                        .textCase(.uppercase)
                                    Spacer()
                                        .frame(height: 10)
                                    Text(day)
                                        .foregroundColor(cur != selected ? Color("c-black") : Color("c-cream"))
                                    
                                }.font(.custom("FoundersGrotesk-Medium", size: 22))
                                    .frame(width: 50, height: 90)
                                    .background(Color("c-black").opacity(cur != selected ? 0 : 1))
                                    .cornerRadius(40)
                            }
                        }
                    }
                }.padding(.horizontal, 5)
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
        .sheet(isPresented: $hInt.editHabit, content: {
            let _ = print(hInt.habit)
            HabitView(editor: true, pageOpen: $hInt.editHabit, habit: hInt.habit)
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

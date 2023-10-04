//
//  DateView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 10/3/23.
//

import SwiftUI
import SwiftData

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
                    VStack {
                        Text(weekday).header5()
                            .foregroundColor(.gray)
                            .textCase(.uppercase)
                        Spacer()
                            .frame(height: 12)
                        Text(day)
                            .foregroundColor(.blck).header5()
                    }.padding(.bottom, -5)
                }.frame(width: 50, height: 90)
                    .cornerRadius(40)
            } else { // habits occur
                VStack(alignment: .center) {
                    VStack {
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
                    }.padding(.bottom, -5)
                }.frame(width: 50, height: 85)
                    .cornerRadius(40)
                    .padding(.top, 5)
            }
        } else {
            VStack(alignment: .center) {
                VStack {
                    Text(weekday).header5()
                        .foregroundColor(.cream)
                        .textCase(.uppercase)
                        .padding(.top, -1)
                        .padding(.bottom, 2)
                    Spacer()
                        .frame(height: 10)
                    Text(day)
                        .foregroundColor(.cream).header5()
                }.padding(.bottom, -5)
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

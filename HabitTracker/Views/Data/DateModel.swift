//
//  DateModel.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/5/23.
//

import SwiftUI

class DateModel: ObservableObject {
    @Published var formatter: DateFormatter
    let weekdays: [String] = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    init() {
        let fm = DateFormatter()
        fm.dateFormat = "MM-dd-YYYY"
        formatter = fm
    }
    
    func getDay(date: Date) -> String {
        formatter.dateFormat = "dd"
        var day = formatter.string(from: date)
        if day.starts(with: "0") { day.remove(at: day.startIndex) }
        return day
    }

    func getWeekday(date: Date, short: Bool) -> String {
        if short {
            formatter.dateFormat = "EEEEEE"
        } else {
            formatter.dateFormat = "EEEE"
        }
        return formatter.string(from: date)
    }
    
    func getDateCarousel() -> [Date] {
        var results: [Date] = []
        let anchor = Date()
        let calendar = Calendar.current
        
        for dayOffset in -6...6 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                results.append(date)
            }
        }
        results = Array(results.dropFirst())
        return results
    }
    
    func getFirstOccurence(date: Date, occurences: [String]) -> Date {
        
        let weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        let start = getWeekday(date: date, short: true)
        if let startIndex = weekdays.firstIndex(where: { $0 == start }) {
            
            var k = 0
            for i in stride(from: startIndex, to: weekdays.count, by: 1) {
                if occurences.contains(weekdays[i]) {
                    let ret = Calendar.current.date(byAdding: .day, value: k, to: date)!
                    return ret
                }
                k += 1
            }
            
            for i in stride(from: 0, to: startIndex, by: 1) {
                if occurences.contains(weekdays[i]) {
                    let ret = Calendar.current.date(byAdding: .day, value: k, to: date)!
                    return ret
                }
                k += 1
            }
        }
        
        return Date.now
    }
    
    func getThisWeek() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1 // Start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
}

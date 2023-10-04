//
//  ExtOther.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 10/4/23.
//

import SwiftUI


// MARK: Double
extension Double {
    func getDigits() -> Double {
        if self < 10 {
            return 40
        }
        return 35
    }
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

// MARK: PresentationDetent
extension PresentationDetent {
    static let small = Self.fraction(0.35)
}

// MARK: Date
extension Date {
    public var removeTimeStamp: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.month, .day, .year], from: self))!
   }
}

// MARK: Functions
func getDateAhead(val: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: val, to: Date().removeTimeStamp)!
}


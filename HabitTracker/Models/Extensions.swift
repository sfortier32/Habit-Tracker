//
//  Extensions.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftUI

// MARK: Text
extension Text {
    func header1() -> Text { return self.font(.custom("FoundersGrotesk-Medium", size: 38)) }
    func header2() -> Text { return self.font(.custom("FoundersGrotesk-Medium", size: 28)) }
    func header3() -> Text { return self.font(.custom("FoundersGrotesk-Medium", size: 26)) }
    func header4() -> Text { return self.font(.custom("FoundersGrotesk-Medium", size: 24)) }
    
    func largerText() -> Text { return self.font(.custom("FoundersGrotesk-Regular", size: 26)) }
    func largeText() -> Text { return self.font(.custom("FoundersGrotesk-Regular", size: 24)) }
    func text1() -> Text { return self.font(.custom("FoundersGrotesk-Regular", size: 22)) }
    func text2() -> Text { return self.font(.custom("FoundersGrotesk-Regular", size: 20)) }
    func text3() -> Text { return self.font(.custom("FoundersGrotesk-Regular", size: 18)) }
    func text4() -> Text { return self.font(.custom("FoundersGrotesk-Regular", size: 16)) }
    func text5() -> Text { return self.font(.custom("FoundersGrotesk-Regular", size: 14)) }
}


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


// MARK: Color
extension Color {
    static var background = Color("c-background")
    static var darkgray = Color("c-darkgray")
    static var shadow = Color("c-shadow")
    static var cream = Color("c-cream")
    static var blck = Color("c-black")
    static var grn = Color("c-green")
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


//
//  Extensions.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftUI

extension View {
    var listStyle: some View {
        return self.listRowBackground(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("c-background"))
                .padding(.horizontal, 15).padding(.vertical, 5)
            )
            .padding(.all, 12)
            .listRowSeparator(.hidden)
    }
    var customStyle: some View {
        return self.scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
        .font(.custom("FoundersGrotesk-Regular", size: 20))
        .baselineOffset(-5)
    }
    
    // MARK: Text
    func header1() -> some View { return self.font(.custom("FoundersGrotesk-Medium", size: 38)) }
    func header2() -> some View { return self.font(.custom("FoundersGrotesk-Medium", size: 28)) }
    func header3() -> some View { return self.font(.custom("FoundersGrotesk-Medium", size: 26)) }
    func header4() -> some View { return self.font(.custom("FoundersGrotesk-Medium", size: 24)) }
    func header5() -> some View { return self.font(.custom("FoundersGrotesk-Medium", size: 22)) }
    
    func bold1() -> some View { return self.font(.custom("FoundersGrotesk-Medium", size: 20)) }
    func bold2() -> some View { return self.font(.custom("FoundersGrotesk-Medium", size: 18)) }
    
    func largerText() -> some View { return self.font(.custom("FoundersGrotesk-Regular", size: 26)) }
    func largeText() -> some View { return self.font(.custom("FoundersGrotesk-Regular", size: 24)) }
    
    func text1() -> some View { return self.font(.custom("FoundersGrotesk-Regular", size: 22)) }
    func text2() -> some View { return self.font(.custom("FoundersGrotesk-Regular", size: 20)) }
    func text3() -> some View { return self.font(.custom("FoundersGrotesk-Regular", size: 18)) }
    func text4() -> some View { return self.font(.custom("FoundersGrotesk-Regular", size: 16)) }
    func text5() -> some View { return self.font(.custom("FoundersGrotesk-Regular", size: 14)) }
    
    func cust(_ size: Int, _ bold: Bool) -> some View {
        if bold {
            return self.font(.custom("FoundersGrotesk-Medium", size: CGFloat(size)))
        } else {
            return self.font(.custom("FoundersGrotesk-Regular", size: CGFloat(size)))
        }
    }
    
    // MARK: Positions
    func center() -> some View {
        return self.frame(maxWidth: .infinity, alignment: .center)
    }
    func leading() -> some View {
        return self.frame(maxWidth: .infinity, alignment: .leading)
    }
    func trailing() -> some View {
        return self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    
    // MARK: Spacing
    func VSpacer(_ h: Int) -> some View {
        return Spacer().frame(height: CGFloat(h))
    }
    func Separator() -> some View {
        return {
            VStack {
                VSpacer(24)
                Divider()
                VSpacer(24)
            }
        }()
    }
    
    // MARK: Masks
    func VMask() -> some View {
        self.mask(
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(
                    colors: [Color.black.opacity(0), Color.black]),
                    startPoint: .top, endPoint: .bottom
                ).frame(height: 10)
                
                Rectangle().fill(Color.black)
                
                LinearGradient(gradient: Gradient(
                    colors: [Color.black, Color.black.opacity(0)]),
                    startPoint: .top, endPoint: .bottom
                ).frame(height: 10)
            }
        )
    }
    func HMask() -> some View {
        self.mask(
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(
                    colors: [Color.black.opacity(0), Color.black]),
                    startPoint: .leading, endPoint: .trailing
                ).frame(height: 10)
                
                Rectangle().fill(Color.black)
                
                LinearGradient(gradient: Gradient(
                    colors: [Color.black, Color.black.opacity(0)]),
                    startPoint: .leading, endPoint: .trailing
                ).frame(height: 10)
            }
        )
    }
}

// MARK: Image
extension Image {
    func resize(w: Int, h: Int) -> some View {
        return self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(w), height: CGFloat(h))
        }
    func resize(w: Int) -> some View {
        return self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(w))
        }
    func resize(h: Int) -> some View {
        return self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: CGFloat(h))
        }
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
    static var grayshadow = Color("c-grayshadow")
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

//
//  ExtStyle.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 10/4/23.
//

import SwiftUI


// MARK: Text
extension View {
    
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
    func HSpacer(_ w: Int) -> some View {
        return Spacer().frame(width: CGFloat(w))
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

//
//  Badges.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/28/23.
//

import SwiftUI
import SwiftData

// MARK: BadgeListView
struct BadgeListView: View {
    var badges: [String:Bool]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(badges.keys).sorted(), id: \.self) { key in
                    BadgeView(imageName: key, unlocked: badges[key]!)
                }
            }.padding(.horizontal)
        }
    }
}

// MARK: BadgeView
struct BadgeView: View {
    var imageName: String
    var unlocked: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 120, height: 120)
            .foregroundColor(Color.background)
            .overlay {
                Image(imageName)
                    .resize(h: 100)
                    .shadow(color: .black.opacity(0.25), radius: 7, x: 0, y: 5)
            }.opacity(unlocked ? 1 : 0.5)
    }
}

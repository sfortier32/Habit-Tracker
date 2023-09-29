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
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .shadow(color: .black.opacity(0.25), radius: 7, x: 0, y: 5)
            }.opacity(unlocked ? 1 : 0.5)
    }
}

struct NewBadgePopUp: View {
    @State var name: String
    @State var confettiVisible = true
    
    @Environment(\.modelContext) var mc
    @Query var ach: [Achievements]
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            VStack {
                Spacer()
                if name.starts(with: "streaks") {
                    Text("You have held a\nstreak for \(ach[0].streakNames[name]!)!").header1()
                        .multilineTextAlignment(.center)
                } else {
                    Text("You have completed \(ach[0].taskNames[name]!)!").header1()
                        .multilineTextAlignment(.center)
                }
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .shadow(color: .yellow.opacity(0.6), radius: 40, x: 0, y: 0)
                Spacer()
                Text("Tap to continue").text1().foregroundColor(.darkgray)
            }.padding()
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
              confettiVisible = false
            }
        })
        .withConfetti(isVisible: $confettiVisible)
    }
}

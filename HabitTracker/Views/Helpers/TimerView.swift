//
//  TimerView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftUI

struct TimerView: View {
    var hb: Habit
    var timer = Timer()
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            VStack {
                // MARK: Header
                Spacer().frame(height: 30)
                Text("Activity Timer")
                    .font(.custom("FoundersGrotesk-Medium", size: 24))
                Spacer().frame(height: 30)
                Divider()
                
                
                
                Spacer()
            }
        }.onAppear {
            
        }
    }
}

#Preview {
    TimerView(hb: Habit(title: "Go for a run", weekDays: ["Mo", "We", "Fr"], freqType: "minutes", frequency: 25, imageName: "figure.run"))
}

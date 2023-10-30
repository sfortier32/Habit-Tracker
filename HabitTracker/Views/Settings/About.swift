//
//  AboutView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftUI

struct About: View {
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Instructions").padding(.bottom, 2).cust(32, true)
                    Text("Home").header2().padding(.bottom, 2)
                    Text("From the home page, you can view your past and upcoming habit tasks. You can also navigate to other pages, create a new habit, open activity timers, and edit existing habits.")
                    VSpacer(20)
                    
                    Text("Adding New Habits").header4().padding(.bottom, 2)
                    Text("To create a new habit, press the plus button in the top right hand corner of the home page.\n\n Every habit must have a name, at least one day of the week picked, and a frequency to be created. The default frequency is 1 time per day, but you can set a custom amount using the \"Other\" option which lets you enter your own unit (i.e., oz). Decimal values can be entered up to two places allowing for frequencies such as two and a half minutes. Values cannot go below 0.01 or exceed 9,999.99")
                    VSpacer(20)
                    
                    Text("Editing Existing Habits").header4().padding(.vertical, 4)
                    Text("You can edit every field of an existing habit by clicking on the name of the habit under any date where it's active on the home page. All changes must be saved by pressing the \"Submit\" button.")
                    VSpacer(20)
                    
                    Text("Deleting Habits & Changing Status").header4().padding(.vertical, 4)
                    Text("A habit can fall into one of four categories: not done, done, skipped, and msised. A habit is missed if it is not completed on the day it should be done. However, missed habits can still still have their status changed. To change a habit status, swipe left on the habit and press \"Done\" or \"Skip.\" If a habit is already done and \"Done\" is pressed again, the habit will return to being not done. The same goes for skipping. Swiping right on the habit allows you to delete the habit permanently.")
                    VSpacer(20)
                    
                    Text("Activity Timers").header4().padding(.vertical, 4)
                    Text("You can open a timer for a habit by pressing on the timer image on a habit if that habit's unit is in minutes and the habit is marked \"Not Done.\" The timer can be started and paused with progress being saved if the timer is exited. Time will not run if the timer page is closed. However, using the timer is optional and habits can still be marked complete regardless of whether it is used.")
                    VSpacer(30)
                    
                    Text("Statistics").header2().padding(.bottom, 2)
                    Text("Here, you can view statistics about streaks and habit streak completion throughout the current week.")
                    VSpacer(30)
                    
                    Text("Achievements").header2().padding(.vertical, 4)
                    Text("The requirements for an achievement are listed on a badge and the badge will be unlocked if said requirements are met. New badges will be displayed with confetti upon entering the achievements page once they have been unlocked. Progress can be reset at any time in settings.")
                    VSpacer(30)
                    
                    
                    Text("Attributions").padding(.bottom, 2).cust(32, true)
                    Text("All code for the confetti effects was provided by @shaundon on GitHub under the repository \"ConfettiDemo.\"")
                    
                }
                .font(.custom("FoundersGrotesk-Regular", size: 22))
                .padding(.top, 12)
            }
            .VMask()
            .padding()
            .navigationTitle("About")
        }
    }
}

#Preview {
    About()
}

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
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Home Page").header3().padding(.bottom, 2)
                    Text("Navigation").header4().padding(.vertical, 4)
                    Text("From the home page, you can view your past and upcoming habit tasks. You can also navigate to other pages, create a new habit, and edit habit categories from the button on the upper right hand corner of the screen.")
                    Spacer().frame(height: 10)
                    Text("Interacting With Habits").header4().padding(.vertical, 4)
                    Spacer().frame(height: 25)
                    
                    Text("Adding New Habits").header3().padding(.bottom, 2)
                    Text("Every habit must have a name, at least one day of the week picked, and a frequency to be created. The default frequency is 1 time per day, but you can set a custom amount using the \"Other\" option which lets you enter your own unit (i.e., oz). Decimal values can be entered up to two places allowing for frequencies such as two and a half minutes.")
                    Spacer().frame(height: 25)
                    
                }
                .font(.custom("FoundersGrotesk-Regular", size: 22))
            }.padding()
            .navigationTitle("About")
        }
    }
}

#Preview {
    About()
}

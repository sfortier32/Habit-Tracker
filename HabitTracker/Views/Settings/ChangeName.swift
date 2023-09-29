//
//  ChangeNameView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/4/23.
//

import SwiftUI

struct ChangeName: View {
    @State var name = ""
    @State var ud = UserDefaults.standard
    @Binding var bool: Bool
    
    var body: some View {
        ZStack {
            Color.grn
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 18)
                HStack {
                    Text("Change Name").font(.custom("FoundersGrotesk-Medium", size: 26))
                    Spacer()
                }
                
                Spacer().frame(height: 18)
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 55)
                    .foregroundColor(.cream)
                    .overlay {
                        TextField("First Name", text: $name)
                            .font(.custom("FoundersGrotesk-Regular", size: 22))
                            .foregroundColor(Color("c-black"))
                            .baselineOffset(-3)
                            .padding()
                            .padding(.leading, 5)
                            .disableAutocorrection(true)
                    }
                Spacer()
                Button("Submit") {
                    ud.set(name, forKey: "name")
                    bool.toggle()
                }.disabled(name.isEmpty)
                    .font(.custom("FoundersGrotesk-Regular", size: 24))
                
                Spacer()
            }.padding()
        }
    }
}

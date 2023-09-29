//
//  TermsView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 8/31/23.
//

import SwiftUI
import CoreData

struct TermsView: View {
    @State var name: String = ""
    @State var error: Bool = false
    @State var emptyError: Bool = false
    @Environment(\.modelContext) private var mc
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.grn
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Spacer().frame(height: 15)
                    Text("Welcome to Habit Tracker!")
                        .font(.custom("FoundersGrotesk-Medium", size: 60))
                        .foregroundColor(.blck)
                    Spacer().frame(height: 15)
                    
                    Text("Enter your name so we know what to call you")
                        .font(.custom("FoundersGrotesk-Medium", size: 30))
                        .foregroundColor(.cream)
                    Spacer().frame(height: 15)
                    
                    Rectangle()
                        .frame(height: 70)
                        .foregroundColor(.cream)
                        .cornerRadius(20)
                        .overlay {
                            TextField("First Name", text: $name)
                                .font(.custom("FoundersGrotesk-Medium", size: 30))
                                .foregroundColor(.blck)
                                .baselineOffset(-3)
                                .padding()
                                .padding(.leading, 10)
                                .disableAutocorrection(true)
                        }
                    // MARK: Display Error Messages
                    VStack {
                        if error {
                            Text("The system experienced an error. Try again later.")
                        }
                        if emptyError {
                            Text("Name cannot be blank.")
                        }
                    }
                    .font(.custom("FoundersGrotesk-Medium", size: 22))
                    .foregroundColor(.blue)
                    .padding()
                    Spacer()
                }
                .padding(25)
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        Button {
                            // MARK: Save Name
                            if name != "" {
                                self.emptyError = false
                                UserDefaults.standard.set(name, forKey: "name")
                                UserDefaults.standard.set(true, forKey: "nameEntered")
                            } else {
                                self.emptyError = true
                            }
                            
                        } label: {
                            Text("Submit")
                                .foregroundColor(.blck)
                                .font(.custom("FoundersGrotesk-Medium", size: 32))
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 20)
                
            }
        }.onAppear {
            let _ = self.mc.insert(Achievements())
        }
    }
}

#Preview {
    TermsView()
        .modelContainer(for: [Habit.self], inMemory: true)
}

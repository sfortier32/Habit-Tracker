//
//  SettingsView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/1/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @EnvironmentObject var tm: TabModel
    @Environment (\.modelContext) var mc
    
    @State private var changeName: Bool = false
    @State private var resetDataAlert: Bool = false
    @State private var resetAchievementsAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.cream.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Settings").header1().padding(.top, 24)
                        Spacer()
                    }.padding()
                    
                    List {
                        // MARK: About
                        NavigationLink("About") {
                            About()
                        }.listRowBackground(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("c-background"))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                        )
                        .padding(.all, 12)
                        .listRowSeparator(.hidden)
                        
                        // MARK: Change Name
                        Button("Change Name") {
                            changeName.toggle()
                        }.listRowBackground(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("c-background"))
                                .padding(.horizontal, 15).padding(.vertical, 5)
                        ).padding(.all, 12).listRowSeparator(.hidden)
                        
                        // MARK: Reset Data
                        Button("Reset All Data") {
                            resetDataAlert.toggle()
                        }.listRowBackground(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("c-background"))
                                .padding(.horizontal, 15).padding(.vertical, 5)
                        ).padding(.all, 12).listRowSeparator(.hidden)
                        
                        Button("Reset Achievements") {
                            resetAchievementsAlert.toggle()
                        }.listRowBackground(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("c-background"))
                                .padding(.horizontal, 15).padding(.vertical, 5)
                        ).padding(.all, 12).listRowSeparator(.hidden)
                        
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                    .font(.custom("FoundersGrotesk-Regular", size: 20))
                    .baselineOffset(-5)
                    
                    Spacer()
                    Text("© Sophia Fortier, 2023").text3()
                        .padding(.bottom, 10)
                    
                    TabsView()
                        .environmentObject(tm)
                    
                    
                }.alert("Reset Achievements", isPresented: $resetAchievementsAlert, actions: {
                    Button("Yes", role: .destructive, action: {
                        try? mc.delete(model: Achievements.self)
                        mc.insert(Achievements())
                    })
                    Button("Cancel", role: .cancel, action: { print(resetAchievementsAlert) })
                }, message: {
                    Text("Are you sure you want to reset all achievement progress?")
                })
                .alert("Reset All Data", isPresented: $resetDataAlert, actions: {
                    Button("Yes", role: .destructive, action: { resetData() })
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Reseting your data will delete all habits, achievements, and force the app to close. Are you sure you want to continue?")
                })
                
            }.sheet(isPresented: $changeName) {
                ChangeName(bool: $changeName)
                    .modelContext(self.mc)
                    .presentationDetents([.small])
            }
        }
    }
    func resetData() {
        try? mc.delete(model: Habit.self)
        try? mc.delete(model: Achievements.self)
        // TODO: Delete all categories/reset to one "uncategorized"
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        exit(0)
    }
}

#Preview {
    SettingsView()
        .environmentObject(TabModel())
        .modelContainer(for: [Habit.self, Achievements.self], inMemory: true)
}

//
//  ContentView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/3/23.
//

import SwiftUI
//import SwiftData

struct ViewController: View {
    @EnvironmentObject var tm: TabModel
    @EnvironmentObject var dm: DateModel
    @Environment(\.modelContext) var mc
    
    var body: some View {
        switch tm.selected {
        case .home:
            HomeView()
                .environmentObject(tm)
                .environmentObject(dm)
                .modelContext(self.mc)
        case .stats:
            StatsView()
                .environmentObject(tm)
                .modelContext(self.mc)
        case .settings:
            SettingsView()
                .environmentObject(tm)
                .modelContext(self.mc)
        }
    }
}

#Preview {
    ViewController()
        .environmentObject(TabModel())
        .environmentObject(DateModel())
        .modelContainer(PreviewSampleData.container)
}

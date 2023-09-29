//
//  TabModel.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 9/3/23.
//

import SwiftUI

class TabModel: ObservableObject {
    
    @Published var selected: Tab = .home
    
    enum Tab: String, CaseIterable {
        case home = "house"
        case stats = "chart.bar"
        case settings = "gearshape"
    }
}

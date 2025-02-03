//
//  Completion.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 2/2/25.
//

import Foundation

enum Completion: Identifiable {
    var id: Self {
        return self
    }
    case done, notDone, skipped, missed
}

//
//  TabsView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 8/31/23.
//

import SwiftUI

struct TabsView: View {
    @EnvironmentObject var tm: TabModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(40)
                .foregroundColor(.blck)
                .padding([.horizontal, .bottom])
                .overlay {
                    HStack(spacing: 48) {
                        ForEach(TabModel.Tab.allCases, id: \.rawValue) { tabType in
                            let name = tabType == tm.selected ? tabType.rawValue + ".fill" : tabType.rawValue
                            Button {
                                // MARK: Change View
                                tm.selected = tabType
                            } label: {
                                Image(systemName: name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                                    .foregroundColor(.grayshadow.opacity(0.5))
                            }
                        }
                        .offset(y: -8)
                    }
                }
            }
    }
}

#Preview {
    TabsView()
        .environmentObject(TabModel())
}

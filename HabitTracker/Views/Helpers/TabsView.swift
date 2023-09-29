//
//  TabsView.swift
//  HabitTracker
//
//  Created by Sophia Fortier on 8/31/23.
//

import SwiftUI

struct TabsView: View {
    @EnvironmentObject var tm: TabModel
    @State var addHabit = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(40)
                .foregroundColor(.blck)
                .padding([.horizontal, .bottom])
                .overlay {
                    HStack {
                        Spacer()
                        Button {
                            // MARK: Add Habit
                            addHabit.toggle()
                        } label: {
                            Rectangle()
                                .frame(width: 130, height: 60)
                                .cornerRadius(30)
                                .overlay {
                                    HStack {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 15)
                                            .fontWeight(.semibold)
                                        Text("New Habit")
                                            .font(.custom("FoundersGrotesk-Medium", size: 18))
                                            .baselineOffset(-6)
                                    }
                                    .foregroundColor(.blck)
                                }
                                .foregroundColor(.grn)
                                .offset(x: -12, y: -8)
                        }
                        Spacer()
                        ForEach(TabModel.Tab.allCases, id: \.rawValue) { tabType in
                            let name = tabType == tm.selected ? tabType.rawValue + ".fill" : tabType.rawValue
                            Button {
                                // MARK: Change View
                                tm.selected = tabType
                            } label: {
                                Image(systemName: name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 28)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .offset(x: -19, y: -8)
                    }
                }
            }.sheet(isPresented: $addHabit) {
                AddHabitView(addHabit: $addHabit)
            }
    }
}

#Preview {
    TabsView()
        .environmentObject(TabModel())
}

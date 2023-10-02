//
//  StatsView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/1/23.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    
    @Query(sort: \Habit.title) var habits: [Habit]
    @EnvironmentObject var tm: TabModel
    @EnvironmentObject var dm: DateModel
    @Environment (\.modelContext) var mc
    
    @State var bigStreaks = UserDefaults.standard.bool(forKey: "bigStreaks")
    let bigCols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    let smallCols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12),
                     GridItem(.flexible(), spacing: 12)]
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Statistics").header1().padding(.top, 24)
                    .padding([.top, .horizontal])
                    .padding(.bottom, 4)
                
                ScrollView(showsIndicators: false) {
                    // MARK: Streaks
                    HStack {
                        Text("Streaks").header2()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .baselineOffset(-8)
                        Button {
                            bigStreaks.toggle()
                            UserDefaults.standard.set(bigStreaks, forKey: "bigStreaks")
                        } label: {
                            Image(systemName: bigStreaks ? "arrow.down.left.square" : "arrow.up.right.square")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                        }
                    }.padding(.horizontal)
                        .padding(.top, 4)
                    
                    if bigStreaks {
                        LazyVGrid(columns: bigCols, spacing: 12) {
                            ForEach(habits) { hb in
                                Rectangle()
                                    .fill(Color.background)
                                    .frame(height: UIScreen.main.bounds.width/2.75)
                                    .cornerRadius(10)
                                    .overlay {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text("\(hb.streak)").cust(32, true)
                                                    Spacer()
                                                    Image(systemName: hb.imageName)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 25, height: 25)
                                                } // end hstack
                                                Spacer()
                                                Text("\(hb.title)").text1()
                                            } // end vstack
                                            Spacer()
                                        }.padding(.all, 18) // end hstack
                                    }
                            }
                        }.padding(.horizontal, 16)
                    } else {
                        LazyVGrid(columns: smallCols, spacing: 12) {
                            ForEach(habits) { hb in
                                Rectangle()
                                    .fill(Color.background)
                                    .frame(height: UIScreen.main.bounds.width/7)
                                    .cornerRadius(10)
                                    .overlay {
                                        HStack {
                                            Text("\(hb.streak)").cust(30, true)
                                                .baselineOffset(-10)
//                                                .border(.red)
                                            Spacer().frame(width: 20)
                                            Image(systemName: hb.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 24, height: 24)
                                        }.padding(.all, 18) // end hstack
//                                            .border(.black)
                                    }
                            }
                        }.padding(.horizontal, 16)
                    }
                    Spacer().frame(height: 30)
                    
                    // MARK: Weekly
                    Text("Weekly").header2()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    VStack(spacing: 14) {
                        ForEach(habits) { hb in
                            HStack {
                                VStack {
                                    Spacer()
                                    Text(hb.title).text2()
                                        .frame(maxWidth: 120, alignment: .leading)
                                }
                                HStack {
                                    ForEach(dm.getThisWeek(), id: \.self) { day in
                                        let weekday = dm.getWeekday(date: day, short: true)
                                        VStack {
                                            Text(weekday)
                                                .cust(14, true)
                                                .textCase(.uppercase)
                                                .padding(.bottom, -2)
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 26, height: 26)
                                                .foregroundColor(!hb.weekDays.contains(weekday) ? .grayshadow.opacity(.5) : (
                                                    hb.done.contains(day) ? .grn : (
                                                    hb.missed.contains(day) ? .red : (
                                                    hb.skipped.contains(day) ? .blue : .grayshadow))))
                                        }.frame(width: 30)
                                    }
                                }
                            }.padding()
                                .background(Color.background)
                                .cornerRadius(10)
                                .clipped()
                        }
                    }.frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                }
                .foregroundColor(.blck)
                .mask(
                    VStack(spacing: 0) {
                        // Top gradient
                        LinearGradient(gradient:
                           Gradient(
                               colors: [Color.black.opacity(0), Color.black]),
                               startPoint: .top, endPoint: .bottom
                           )
                           .frame(height: 10)

                        // Middle
                        Rectangle().fill(Color.black)

                        // Bottom gradient
                        LinearGradient(gradient:
                           Gradient(
                               colors: [Color.black, Color.black.opacity(0)]),
                               startPoint: .top, endPoint: .bottom
                           )
                           .frame(height: 10)
                    }
                 )
                
                
                TabsView()
                    .environmentObject(tm)
            }
        }.onAppear(perform: {
            self.calculateStreaks()
        })
    }
    func calculateStreaks() -> Void {
        for hb in habits {
            if let last = hb.missed.last {
                hb.streak = hb.allTypesDone.lazy.filter{ $0 > last }.count
            } else {
                hb.streak = hb.allTypesDone.count
            }
        }
    }
}

#Preview {
    StatsView()
        .environmentObject(TabModel())
        .environmentObject(DateModel())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Achievements.self], inMemory: true)
}

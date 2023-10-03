//
//  HabitRow.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/13/23.
//

import SwiftUI

struct HabitRow: View {
    let hb: Habit
    let date: Date
    
    @State private var currDate = Date.now.removeTimeStamp
    @EnvironmentObject var hInt: HabitInteractions
    
    var body: some View {
        HStack {
            // MARK: Image
            Button {
                hInt.habit = hb
                hInt.openHabitView.toggle()
            } label: {
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.grayshadow)
                        .frame(width: 36, height: 36)
                        .overlay {
                            Image(systemName: hb.imageName)
                                .resize(w: 18, h: 18)
                        }
                        .padding(.trailing, 8)
                        .padding(.bottom, 10)
                    
                    // MARK: Title
                    VStack(alignment: .leading) {
                        if hb.notDone.contains(self.date) {
                            Text("\(hb.title)")
                            
                            // MARK: New/Not Done
                            if self.date == hb.dateAdded || self.date == hb.firstOccurence {
                                HStack {
                                    Image(systemName: "burst.fill")
                                        .resize(h: 12)
                                    Text("New").text4()
                                        .baselineOffset(-5)
                                }.foregroundColor(.pink)
                                    .padding(.top, -12)
                            } else {
                                Text("Not Done").text4()
                                    .foregroundColor(.darkgray)
                            }
                            
                            // MARK: Missed
                        } else if hb.missed.contains(self.date) {
                            Text("\(hb.title)")
                            Text("Missed").text4()
                                .foregroundColor(.red)
                            
                            
                            // MARK: Skipped
                        } else if hb.skipped.contains(self.date) {
                            Text("\(hb.title)")
                                .strikethrough()
                            HStack {
                                Image(systemName: "arrow.uturn.left")
                                    .resize(h: 10)
                                Text("Skipped").text4()
                                    .baselineOffset(-6)
                            }.foregroundColor(.blue)
                                .padding(.top, -12)
                            
                            
                            // MARK: Done
                        } else if hb.done.contains(self.date) {
                            Text("\(hb.title)")
                                .strikethrough()
                            HStack {
                                Image(systemName: "checkmark")
                                    .resize(h: 10)
                                Text("Done").text4()
                                    .baselineOffset(-6)
                            }.foregroundColor(.green)
                                .padding(.top, -12)
                        }
                    }
                    Spacer()
                    Divider().frame(height: 60)
                }
            }.clipped().buttonStyle(BorderlessButtonStyle())
            
            
            // MARK: Units
            Button {
                if hb.freqType == "times" && currDate == date {
                    hInt.openTimer.toggle()
                }
            } label: {
                VStack {
                    Spacer()
                    if hb.freqType == "minutes" {
                        Image(systemName: "deskclock.fill")
                            .resize(h: 24)
                            .padding(.top, 5)
                    } else {
                        Text(hb.frequency.cleanValue).largerText()
                            .frame(height: 7).padding(.top, 16)
                        
                    }
                    let postfix = hb.freqType == "minutes" ? "min" : (hb.freqType == "times" ? (hb.frequency > 1 ? "times" : "time") : hb.freqType)
                    let prefix = hb.freqType == "minutes" ? hb.frequency.cleanValue + " " : ""
                    Text(prefix + postfix).text4()
                    Spacer()
                }.frame(width: 70, height: 50)
            }.clipped().buttonStyle(BorderlessButtonStyle())
            
        }.frame(height: 70)
            .opacity(hb.notDone.contains(self.date) ? 1 : 0.6)
    }
}

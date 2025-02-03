//
//  ExtList.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftUI

extension View {
    // MARK: SwipeActions
    func customSwipeActions(hb: Habit, date: Date) -> some View {
        return self
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button() { // MARK: Done
                if hb.done.contains(date) { // if marked as done
                    if hb.timers[date] != nil {
                        hb.timers[date] = nil
                    }
                    if hb.freqType == "minutes" {
                        hb.minutes -= Int(hb.frequency)
                    }
                    hb.done.removeAll(where: { $0 == date })
                    if date < Date.now.removeTimeStamp { // return to missed
                        hb.missed.append(date)
                        hb.missed.sort()
                    } else { // return to not done
                        hb.notDone.append(date)
                        hb.notDone.sort()
                    }
                    hb.allTypesDone.removeAll(where: { $0 == date })
                } else {
                    hb.done.append(date)
                    hb.done.sort()
                    if hb.notDone.contains(date) { // notDone -> done
                        hb.notDone.removeAll(where: { $0 == date })
                        hb.allTypesDone.append(date)
                        hb.allTypesDone.sort()
                        if hb.freqType == "minutes" {
                            hb.minutes += Int(hb.frequency)
                        }
                    } else if hb.skipped.contains(date) { // skipped -> done
                        hb.skipped.removeAll(where: { $0 == date })
                    } else { // in missed
                        hb.missed.removeAll(where: { $0 == date }) // missed -> done
                        hb.allTypesDone.append(date)
                        hb.allTypesDone.sort()
                        if hb.freqType == "minutes" {
                            hb.minutes += Int(hb.frequency)
                        }
                    }
                }
            } label: {
                Label(
                    title: { Text("Done") },
                    icon: { Image(systemName: "checkmark") })
            }.tint(.green)
            
            
            Button() { // MARK: Skip
                if hb.skipped.contains(date) { // if marked as skipped
                    if hb.timers[date] != nil {
                        hb.timers[date] = nil
                    }
                    if hb.freqType == "minutes" {
                        hb.minutes -= Int(hb.frequency)
                    }
                    hb.skipped.removeAll(where: { $0 == date })
                    if date < Date.now.removeTimeStamp { // return to missed
                        hb.missed.append(date)
                        hb.missed.sort()
                    } else { // return to not done
                        hb.notDone.append(date)
                        hb.notDone.sort()
                    }
                    hb.allTypesDone.removeAll(where: { $0 == date })
                } else {
                    hb.skipped.append(date)
                    hb.skipped.sort()
                    if hb.notDone.contains(date) { // notDone -> skipped
                        hb.notDone.removeAll(where: { $0 == date })
                        hb.allTypesDone.append(date)
                        hb.allTypesDone.sort()
                    } else if hb.done.contains(date) { // done -> skipped
                        hb.done.removeAll(where: { $0 == date })
                        if hb.freqType == "minutes" {
                            hb.minutes -= Int(hb.frequency)
                        }
                    } else { // missed -> skipped
                        hb.missed.removeAll(where: { $0 == date })
                        hb.allTypesDone.append(date)
                        hb.allTypesDone.sort()
                    }
                }
            } label: {
                Label(
                    title: { Text("Skip") },
                    icon: { Image(systemName: "arrow.uturn.left") })
            }.tint(.blue)
        }
    }
    
    // MARK: List Style
    var customListButton: some View {
        return self.listRowBackground(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.background)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
        )
        .padding(.all, 12)
        .listRowSeparator(.hidden)
    }
    
    
    var customListStyle: some View {
        return self.scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
        .font(.custom("FoundersGrotesk-Regular", size: 20))
        .baselineOffset(-5)
    }
    
    var customListHeader: some View {
        return self
            .leading()
            .text2()
            .listRowBackground(Color.cream.ignoresSafeArea())
            .foregroundColor(.gray)
            .padding(.horizontal, 5)
    }
}

extension View {
    // MARK: Masks
    func VMask() -> some View {
        self.mask(
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(
                    colors: [Color.black.opacity(0), Color.black]),
                    startPoint: .top, endPoint: .bottom
                ).frame(height: 10)
                
                Rectangle().fill(Color.black)
                
                LinearGradient(gradient: Gradient(
                    colors: [Color.black, Color.black.opacity(0)]),
                    startPoint: .top, endPoint: .bottom
                ).frame(height: 10)
            }
        )
    }
    func HMask() -> some View {
        self.mask(
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(
                    colors: [Color.black.opacity(0), Color.black]),
                    startPoint: .leading, endPoint: .trailing
                ).frame(height: 10)
                
                Rectangle().fill(Color.black)
                
                LinearGradient(gradient: Gradient(
                    colors: [Color.black, Color.black.opacity(0)]),
                    startPoint: .leading, endPoint: .trailing
                ).frame(height: 10)
            }
        )
    }
}

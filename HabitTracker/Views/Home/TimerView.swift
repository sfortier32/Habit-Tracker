//
//  TimerView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/25/23.
//

import SwiftUI
import SwiftData


struct TimerView: View {
    var habit: Habit
    var date: Date
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timerOn = false
    @State private var timerDone = false
    @State private var confettiVisible = false
    @State private var restartTimer = false
    
    @Environment(\.modelContext) var mc
    @EnvironmentObject var hInt: HabitInteractions
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            VStack {
                // MARK: Header
                VSpacer(50)
                ZStack {
                    Text("Activity Timer").cust(32, true)
                        .baselineOffset(-6)
                    
                    Button {
                        hInt.openTimer.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resize(w: 22, h: 22)
                            .rotationEffect(Angle(degrees: 45))
                            .text2().trailing().padding(.trailing)
                    }.padding(.horizontal)
                }
                Spacer()
                
                let minutes = String((habit.timers[date] ?? -1) / 60)
                let seconds = String(format: "%02d", (habit.timers[date] ?? -1) % 60)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 200)
                        .fill(Color.green)
                        .frame(width: 375, height: 375)
                        .foregroundColor(Color.green)
                    
                    
                    RoundedRectangle(cornerRadius: 200)
                        .stroke(Color.blck, lineWidth: 5)
                        .fill(Color.grn)
                        .frame(width: 340, height: 340)
                        .foregroundColor(Color.grn)
                    
                    HStack {
                        Spacer()
                        Text(minutes).cust(90, true)
                        Text(":").cust(90, true)
                            .baselineOffset(5)
                        Text(seconds).cust(90, true)
                        Spacer()
                    }
                    .padding(.top, 20)
                    Text("Remaining").header4()
                        .padding(.top, 125)
                }
                
                VSpacer(80)
                Button {
                    if timerDone {
                        hInt.openTimer.toggle()
                    } else {
                        timerOn.toggle()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.blck, lineWidth: 2)
                        .frame(width: 130, height: 55)
                        .overlay {
                            Text(
                                timerDone ? "Close" : (
                                    timerOn ? "Pause" : "Start")
                            ).header2()
                                .padding(.top, 6)
                            
                        }
                }
                VSpacer(40)
                Button {
                    timerOn = false
                    restartTimer.toggle()
                } label: {
                    Text("Restart").text1()
                }.padding(.vertical)
                
                VSpacer(40)
                
            }.onReceive(timer) { _ in
                if timerOn && habit.timers[date]! > 0 {
                    habit.timers[date]! -= 1
                    if habit.timers[date]! == 0 {
                        confettiVisible = true
                        timerDone = true
                        habit.done.append(date)
                        habit.allTypesDone.append(date)
                        habit.minutes += Int(habit.frequency)
                    }
                }
            }
            .confirmationDialog("Are you sure you want to restart the timer?", isPresented: $restartTimer, titleVisibility: .visible) {
                Button("Yes", role: .destructive) {
                    habit.timers[date] = Int(habit.frequency * 60)
                    habit.done.removeAll(where: { $0 == date })
                    timerDone = false
                }
            }
            
        }
        .foregroundColor(.blck)
        .onAppear(perform: {
            if habit.timers[date] == nil {
                habit.timers[date] = Int(habit.frequency * 60)
            }
            timerDone = habit.done.contains(date)
        })
        .onDisappear(perform: {
            if habit.timers[date] == Int(habit.frequency * 60) || habit.timers[date] == 0 {
                habit.timers[date] = nil
            }
        })
        .withConfetti(isVisible: $confettiVisible)
        .onChange(of: confettiVisible, initial: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                confettiVisible = false
            }
        }
        
    }
}

#Preview {
    TimerView(habit: Habit(title: "Go for a run", weekdays: ["Mo", "We", "Fr"], freqType: "minutes", frequency: 0.05, imageName: "figure.run"), date: Date.now.removeTimeStamp)
        .environmentObject(HabitInteractions())
        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}

//
//  HabitView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/4/23.
//

import SwiftUI

struct HabitView: View {
    
    @Environment(\.modelContext) private var mc
    
    var editingHabit: Habit? // Habit to be adjusted/created
    var pageOpen: Binding<Bool> // Bool to open/close view
    @State var editor: Bool // Page Name
    
    // MARK: Habit Features
    @State private var title: String
    @State private var icon: String
    @State private var freq: Double
    @State private var freqType: String
    @State private var days: [String] = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    @State private var selectedDays: [String]
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.minimum = .init(floatLiteral: 1)
        formatter.maximum = .init(floatLiteral: 9999.99)
        return formatter
    }()
    
    init(editor: Bool, pageOpen: Binding<Bool>, habit: Habit?) {
        self.editor = editor
        self.pageOpen = pageOpen
        
        if habit != nil {
            self.editingHabit = habit
            self.title = habit!.title
            self.icon = habit!.imageName
            self.freq = habit!.frequency
            self.freqType = habit!.freqType
            self.selectedDays = habit!.weekDays
        } else {
            self.title = ""
            self.icon = "pills"
            self.freq = 1
            self.freqType = "times"
            self.selectedDays = []
        }
    }
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 15)
                ZStack {
                    HStack {
                        Button {
                            pageOpen.wrappedValue.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .rotationEffect(Angle(degrees: 45))
                                .foregroundColor(.blck)
                        }
                        Spacer()
                    }.padding(.horizontal)
                    Text(editor ? "Edit Habit" : "Add New Habit")
                        .font(.custom("FoundersGrotesk-Medium", size: 24))
                        .baselineOffset(-8)
                }
                Spacer().frame(height: 25)
                
                ScrollView(showsIndicators: false) {
                    // MARK: Habit Name
                    HStack {
                        Text("Habit Name")
                            .font(.custom("FoundersGrotesk-Medium", size: 22))
                        Spacer()
                    }.padding([.leading, .top])
                        .padding(.bottom, 5)
                    
                    TextField("Title", text: $title)
                        .padding()
                        .baselineOffset(-3)
                        .background(Color.background, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    Spacer().frame(height: 25)
                    Divider()
                    
                    // MARK: Days
                    HStack {
                        Text("Days")
                            .font(.custom("FoundersGrotesk-Medium", size: 22))
                        Spacer()
                    }.padding([.leading, .top])
                        .padding(.bottom, 5)
                    
                    HStack {
                        ForEach(days, id: \.self) { day in
                            let inSD = selectedDays.contains(day)
                            Button {
                                if inSD {
                                    selectedDays.removeAll(where: { $0 == day })
                                } else {
                                    selectedDays.append(day)
                                }
                            } label: {
                                Text(day)
                                    .frame(width: 45, height: 45)
                                    .background(Color.black.opacity(inSD ? 1 : 0))
                                    .foregroundColor(inSD ? .cream : .blck)
                                    .cornerRadius(30)
                                    .baselineOffset(-6)
                            }
                        }
                    }
                    
                    Spacer().frame(height: 25)
                    Divider()
                    
                    // MARK: Frequency
                    HStack {
                        Text("Frequency")
                            .font(.custom("FoundersGrotesk-Medium", size: 22))
                        Spacer()
                    }.padding([.leading, .top])
                        .padding(.bottom, 10)
                    
                    HStack {
                        Spacer()
                        Button {
                            freqType = "times"
                        } label: {
                            Text("Times")
                                .font(.custom(freqType == "times" ? "FoundersGrotesk-Medium" : "FoundersGrotesk-Regular", size: 20))
                                .padding([.leading, .trailing], 18)
                                .padding([.top, .bottom], 12)
                                .baselineOffset(-3)
                                .foregroundColor(.blck)
                                .background(freqType == "times" ? Color.grn : Color.background, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                            
                        }
                        Spacer()
                        Button {
                            freqType = "minutes"
                        } label: {
                            Text("Minutes")
                                .font(.custom(freqType == "minutes" ? "FoundersGrotesk-Medium" : "FoundersGrotesk-Regular", size: 20))
                                .padding([.leading, .trailing], 18)
                                .padding([.top, .bottom], 12)
                                .baselineOffset(-3)
                                .foregroundColor(.blck)
                                .background(freqType == "minutes" ? Color.grn : Color.background, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                        }
                        Spacer()
                        Button {
                            freqType = ""
                        } label: {
                            Text("Other")
                                .font(.custom((freqType != "times" && freqType != "minutes") ? "FoundersGrotesk-Medium" : "FoundersGrotesk-Regular", size: 20))
                                .padding([.leading, .trailing], 18)
                                .padding([.top, .bottom], 12)
                                .baselineOffset(-3)
                                .foregroundColor(.blck)
                                .background((freqType != "times" && freqType != "minutes") ? Color.grn : Color.background, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                        }
                        Spacer()
                    }.foregroundColor(.blck)
                    
                    if freqType != "times" && freqType != "minutes" {
                        HStack {
                            Text("Unit:")
                                .font(.custom("FoundersGrotesk-Medium", size: 20))
                            TextField("Pages", text: $freqType)
                                .padding()
                                .baselineOffset(-2)
                                .background(Color.background, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .padding(.leading, 5)
                        }.padding([.vertical, .leading])
                    } else {
                        Spacer().frame(height: 24)
                    }
                    Divider()
                    
                    // MARK: Amount
                    HStack {
                        Text("Amount Per Day")
                            .font(.custom("FoundersGrotesk-Medium", size: 20))
                        Spacer().frame(height: 15)
                        HStack {
                            Button {
                                if freq - 1 >= 1 {
                                    freq -= 1
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            TextField("1", value: $freq, formatter: numberFormatter)
                                .font(.custom("FoundersGrotesk-Regular", size: 26))
                                .frame(width: (String(freq).size(withAttributes: [.font: UIFont.systemFont(ofSize: 20)]).width) + freq.getDigits(), height: 70)
                                .background(Color.background)
                                .cornerRadius(25)
                                .multilineTextAlignment(.center)
                                .baselineOffset(-3)
                            Button {
                                if freq + 1 <= 9999.99 {
                                    freq += 1
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                    }.padding()
                        .foregroundColor(.blck)
                    Divider()
                    
                    // MARK: Icon
                    HStack {
                        Text("Icon")
                            .font(.custom("FoundersGrotesk-Medium", size: 22))
                        Spacer()
                    }.padding([.leading, .top])
                    SymbolPicker(selected: $icon)
                    
                    
                } // end scroll view
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
                
                // MARK: Next
                Spacer().frame(height: 25)
                Button("Submit") {
                    if editor {
                        editingHabit!.title = title
                        editingHabit!.weekDays = selectedDays
                        editingHabit!.freqType = freqType.lowercased()
                        editingHabit!.frequency = freq
                        editingHabit!.imageName = icon
                        try? self.mc.save()
                    } else {
                        let newHabit = Habit(
                            title: title,
                            weekDays: selectedDays,
                            freqType: freqType.lowercased(),
                            frequency: freq,
                            imageName: icon)
                        self.mc.insert(newHabit)
                    }
                    pageOpen.wrappedValue.toggle()
                }.disabled(title.isEmpty || selectedDays.isEmpty)
                
            } // end vstack
            .padding()
            .font(.custom("FoundersGrotesk-Regular", size: 22))
        } // end zstack
    }
}

#Preview {
    HabitView(editor: false, pageOpen: .constant(true), habit: nil)
}

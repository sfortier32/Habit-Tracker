//
//  HabitView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/4/23.
//

import SwiftUI

struct HabitView: View {
    @State var cInt: CategoryInteractions
    @Environment(\.modelContext) var mc
    @EnvironmentObject var hInt: HabitInteractions
    
    var editingHabit: Habit? // Habit to be adjusted/created
    var pageOpen: Binding<Bool> // Bool to open/close view
    @State var editor: Bool // Page Name
    
    // MARK: Habit Features
    @State private var title: String = ""
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
            self.cInt = CategoryInteractions(selected: habit!.category)
        } else {
            self.icon = "pills"
            self.freq = 1
            self.freqType = "times"
            self.selectedDays = []
            self.cInt = CategoryInteractions(selected: nil)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.cream
                    .ignoresSafeArea()
                
                // MARK: Header
                VStack {
                    VSpacer(35)
                    ZStack {
                        Text(editor ? "Edit Habit" : "Add New Habit")
                            .header4()
                            .center()
                            .baselineOffset(-6)
                        Button {
                            pageOpen.wrappedValue.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resize(w: 22, h: 22)
                                .rotationEffect(Angle(degrees: 45))
                                .text2().trailing().padding(.trailing)
                        }.padding(.horizontal)
                    }
                    VSpacer(15)
                    ScrollView(showsIndicators: false) {
                        // MARK: Habit Name
                        Text("Habit Name").header5().leading()
                            .padding(.horizontal)
                            .padding(.top, 12)
                        TextField("Title", text: $title)
                            .padding()
                            .baselineOffset(-3)
                            .background(Color.background, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                        Separator()
                        
                        // MARK: Days
                        Text("Days").header5().leading()
                            .padding(.horizontal)
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
                                    Text(day).text1()
                                        .frame(width: 45, height: 45)
                                        .background(inSD ? .black : .background)
                                        .foregroundColor(inSD ? .cream : .blck)
                                        .cornerRadius(25)
                                        .baselineOffset(-6)
                                }
                            }
                        }
                        Separator()
                        
                        // MARK: Frequency
                        Text("Frequency").header5().leading()
                            .padding(.horizontal)
                        HStack(spacing: 26) {
                            RadioButton(title: "Times", buttonChange: $freqType, buttonEquals: "times", cond: freqType == "times")
                            RadioButton(title: "Minutes", buttonChange: $freqType, buttonEquals: "minutes", cond: freqType == "minutes")
                            RadioButton(title: "Other", buttonChange: $freqType, buttonEquals: "", cond: freqType != "times" && freqType != "minutes")
                        }
                        VSpacer(18)
                        HStack {
                            HStack {
                                Text("Amount:")
                                    .font(.custom("FoundersGrotesk-Medium", size: 20))
                                    .baselineOffset(-4)
                                TextField("20", value: $freq, formatter: numberFormatter)
                                    .padding([.leading, .vertical])
                                    .baselineOffset(-3)
                                    .background(Color.background, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    .padding(.leading, 5)
                            }.padding(.leading)
                        }
                        
                        // MARK: Other
                        if freqType != "times" && freqType != "minutes" {
                            Spacer().frame(height: 16)
                            HStack {
                                Text("Unit:")
                                    .font(.custom("FoundersGrotesk-Medium", size: 20))
                                    .baselineOffset(-4)
                                TextField("Pages", text: $freqType)
                                    .padding([.leading, .vertical])
                                    .baselineOffset(-3)
                                    .background(Color.background, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    .padding(.leading, 5)
                            }.padding(.leading)
                        }
                        Separator()
                        
                        // MARK: Icon
                        VStack(spacing: 12) {
                            NavigationLink {
                                CategoryView()
                                    .environmentObject(cInt)
                            } label: { ListButton("Category") }
                            NavigationLink {
                                SymbolPicker(selected: $icon)
                            } label: { ListButton("Icon") }
                        }.foregroundColor(.blck)
                    }
                    .VMask()
                    .padding()
                    .font(.custom("FoundersGrotesk-Regular", size: 22))
                    
                    Button("Submit") {
                        if editor {
                            editingHabit!.title = title
                            editingHabit!.weekDays = selectedDays
                            editingHabit!.freqType = freqType.lowercased()
                            editingHabit!.frequency = freq
                            editingHabit!.imageName = icon
                            editingHabit!.category = cInt.selected
                            do {
                                try mc.save()
                            } catch {
                                print("Error: HabitView submit if editing")
                            }
                        } else {
                            let newHabit = Habit(
                                title: title,
                                weekDays: selectedDays,
                                freqType: freqType.lowercased(),
                                frequency: freq,
                                imageName: icon)
                            newHabit.category = cInt.selected
                            mc.insert(newHabit)
                            hInt.objectWillChange.send()
                        }
                        pageOpen.wrappedValue.toggle()
                    }.disabled(title.isEmpty || selectedDays.isEmpty)
                        .font(.custom("FoundersGrotesk-Regular", size: 22))
                    VSpacer(18)
                    
                }
            }
        } // end navigation stack
    }
}

struct RadioButton: View {
    var title: String
    @Binding var buttonChange: String
    var buttonEquals: String
    var cond: Bool
    
    var body: some View {
        Button {
            buttonChange = buttonEquals
        } label: {
            Text(title)
                .font(.custom(cond ? "FoundersGrotesk-Medium" : "FoundersGrotesk-Regular", size: 20))
                .padding([.leading, .trailing], 18)
                .padding([.top, .bottom], 12)
                .baselineOffset(-3)
                .foregroundColor(.blck)
                .background(cond ? Color.grn : Color.background, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
            
        }
    }
}


struct ListButton: View {
    var text: String
    init(_ text: String) {
        self.text = text
    }
    var body: some View {
        HStack {
            Text(text)
                .baselineOffset(-4)
                .foregroundColor(.blck)
            Spacer()
            Image(systemName: "chevron.right")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .bold()
                .foregroundColor(.blck)
        }
        .padding()
        .background(Color.background, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal, 12)
    }
}


#Preview {
    HabitView(editor: false, pageOpen: .constant(true), habit: nil)
        .environmentObject(HabitInteractions())
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}

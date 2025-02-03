//
//  SymbolPicker.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/14/23.
//

import SwiftUI

class Symbols: ObservableObject {
    @State var health: [String] = ["pills", "cross.vial", "comb", "waterbottle", "brain", "brain.filled.head.profile", "lungs", "mouth", "heart", "allergens"]
    @State var fitness: [String] = ["figure.walk", "figure.run", "figure.barre", "figure.bowling", "figure.climbing", "figure.indoor.cycle", "figure.mind.and.body", "figure.strengthtraining.traditional", "football", "baseball", "basketball", "soccerball", "tennis.racket", "dumbbell", "bicycle", "sportscourt", "water.waves"]
    @Published var home: [String] = ["stove", "dishwasher", "washer", "dryer", "frying.pan", "cart", "trash"]
    @Published var nature: [String] = ["cat", "dog", "pawprint", "sun.horizon", "sun.max", "moon", "drop", "leaf", "tree"]
    @Published var other: [String] = ["questionmark", "pencil", "book", "books.vertical", "calendar", "bell"]
    @Published var technology: [String] = ["iphone", "macbook", "applewatch", "tv", "headphones", "earbuds", "gamecontroller", "apple.terminal.on.rectangle"]
    
}

struct SymbolPicker: View {
    @Binding var selected: String
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
        ]
    
    @ObservedObject var sym: Symbols = Symbols()
    
    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()
            
            VStack {
                Text("Icon Picker").header2()
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                        // MARK: Health
                        Section {
                            ForEach(sym.health, id: \.self) { icon in
                                Button {
                                    self.selected = icon
                                } label: {
                                    IconDisplay(name: icon, selected: icon == selected)
                                }
                            }.padding(.bottom, 10)
                        } header: {
                            IconHeader(title: "Health").padding(.bottom, 10)
                        }
                        
                        // MARK: Fitness
                        Section {
                            ForEach(sym.fitness, id: \.self) { icon in
                                Button {
                                    self.selected = icon
                                } label: {
                                    IconDisplay(name: icon, selected: icon == selected)
                                }
                            }.padding(.bottom, 10)
                        } header: {
                            IconHeader(title: "Fitness").padding(.bottom, 10)
                        }
                        
                        // MARK: Home
                        Section {
                            ForEach(sym.home, id: \.self) { icon in
                                Button {
                                    self.selected = icon
                                } label: {
                                    IconDisplay(name: icon, selected: icon == selected)
                                }
                            }.padding(.bottom, 10)
                        } header: {
                            IconHeader(title: "Home").padding(.bottom, 10)
                        }
                        
                        // MARK: Technology
                        Section {
                            ForEach(sym.technology, id: \.self) { icon in
                                Button {
                                    self.selected = icon
                                } label: {
                                    IconDisplay(name: icon, selected: icon == selected)
                                }
                            }.padding(.bottom, 10)
                        } header: {
                            IconHeader(title: "Technology").padding(.bottom, 10)
                        }
                        
                        // MARK: Nature
                        Section {
                            ForEach(sym.nature, id: \.self) { icon in
                                Button {
                                    self.selected = icon
                                } label: {
                                    IconDisplay(name: icon, selected: icon == selected)
                                }
                            }.padding(.bottom, 10)
                        } header: {
                            IconHeader(title: "Nature").padding(.bottom, 10)
                        }
                        
                        // MARK: Other
                        Section {
                            ForEach(sym.other, id: \.self) { icon in
                                Button {
                                    self.selected = icon
                                } label: {
                                    IconDisplay(name: icon, selected: icon == selected)
                                }
                            }.padding(.bottom, 10)
                        } header: {
                            IconHeader(title: "Other").padding(.bottom, 10)
                        }
                        
                    }
                }.VMask()
                    .padding([.horizontal, .bottom])
                    .padding(.horizontal, 8)
            }
        }
    }
}



struct IconHeader: View {
    var title: String
    var body: some View {
        HStack {
            Text(title).text2()
                .leading()
                .padding(.top, 10)
                .foregroundColor(.darkgray)
                .background(Color.cream)
            Spacer()
        }
    }
}


struct IconDisplay: View {
    var name: String
    var selected: Bool
    
    var body: some View {
        if selected {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blck)
                .frame(width: 65, height: 65)
                .overlay {
                    Image(systemName: name)
                        .resize(w: 30, h: 30)
                        .foregroundColor(.background)
                }
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.background)
                .frame(width: 65, height: 65)
                .overlay {
                    Image(systemName: name)
                        .resize(w: 30, h: 30)
                        .foregroundColor(.blck)
                }
        }
        
    }
}

#Preview {
    SymbolPicker(selected: .constant("pills"))
}

//
//  CategoryView.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 10/2/23.
//

import SwiftUI
import SwiftData

class CategoryInteractions: ObservableObject {
    @Published var selected: Category?
    init(selected: Category?) {
        if selected != nil {
            self.selected = selected
        } else {
            self.selected = nil
        }
    }
}

// MARK: CategoryView
struct CategoryView: View {
    @State var addCategory: Bool = false
    @Environment(\.modelContext) var mc
    @EnvironmentObject var cInt: CategoryInteractions
    
    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()
            VStack {
                ZStack {
                    Text("Categories").header2().center()
                        .baselineOffset(-6)
                    Button {
                        addCategory.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resize(h: 22)
                            .trailing()
                    }.padding(.horizontal)
                }
                CategoryList()
                    .environmentObject(cInt)
            }
        }.sheet(isPresented: $addCategory) {
            AddCategory(bool: $addCategory)
                .environmentObject(cInt)
                .presentationDetents([.small])
        }
    }
}

// MARK: CategoryList
struct CategoryList: View {
    @Environment(\.modelContext) var mc
    @EnvironmentObject var cInt: CategoryInteractions
    @Query(sort: \Category.orderIndex) private var categs: [Category]
    @Query var habits: [Habit]
    
    var body: some View {
        List {
            Button {
                cInt.selected = nil
            } label: {
                HStack {
                    Text("None")
                    Spacer()
                    if cInt.selected == nil {
                        Image(systemName: "checkmark")
                            .resize(w: 14, h: 14)
                            .bold().foregroundColor(Color.blck.opacity(0.8))
                    }
                }
            }.customListButton
            
            ForEach(categs) { cg in
                Button {
                    cInt.selected = cg
                } label: {
                    HStack {
                        Text(cg.title)
                        Spacer()
                        if cInt.selected == cg {
                            Image(systemName: "checkmark")
                                .resize(w: 14, h: 14)
                                .bold().foregroundColor(Color.blck.opacity(0.8))
                        }
                    }
                }.customListButton
                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                    Button(role: .destructive) {
                        // TODO: Add message
                        cInt.selected = nil
                        mc.delete(cg)
                    } label: {
                        Image(systemName: "trash")
                    }
                })
            }.onMove { from, to in
                var updatedCategs = categs
                updatedCategs.move(fromOffsets: from, toOffset: to)
                for (index, categ) in updatedCategs.enumerated() {
                    categ.orderIndex = index
                }
            }
        }.customListStyle
    }
}


// MARK: AddCategory
struct AddCategory: View {
    @State var title: String = ""
    @Binding var bool: Bool
    
    @Environment(\.modelContext) var mc
    @EnvironmentObject var cInt: CategoryInteractions
    @Query(sort: \Category.orderIndex) private var categs: [Category]
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 18)
                HStack {
                    Text("Create New Category").header3()
                    Spacer()
                }
                
                Spacer().frame(height: 18)
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 55)
                    .foregroundColor(.cream)
                    .overlay {
                        TextField("Title", text: $title)
                            .font(.custom("FoundersGrotesk-Regular", size: 22))
                            .foregroundColor(Color("c-black"))
                            .baselineOffset(-3)
                            .padding()
                            .padding(.leading, 5)
                            .disableAutocorrection(true)
                    }
                Spacer()
                Button("Submit") {
                    let category = Category(title: title, orderIndex: categs.count)
                    mc.insert(category)
                    cInt.selected = category
                    bool.toggle()
                }.disabled(title.isEmpty)
                    .largeText()
                
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    CategoryView()
        .environmentObject(CategoryInteractions(selected: nil))
        .modelContainer(for: [Habit.self, Category.self, Achievements.self], inMemory: true)
}

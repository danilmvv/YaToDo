//
//  NavBarModifier.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 09/07/24.
//

import SwiftUI

struct NavBarModifier: ViewModifier {
    let title: String = "Мои дела"
    
    @Binding var filter: ModelData.FilterCategory
    @Binding var showCompleted: Bool
    @State private var focusedField: Any? = nil
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        TodoCalendar()
                            .navigationTitle("Календарь")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbarBackground(Color(UIColor.secondarySystemBackground), for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
                
                ToolbarItem {
                    Menu {
                        Picker("Категория", selection: $filter) {
                            ForEach(ModelData.FilterCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Toggle(isOn: $showCompleted) {
                            Text("Показать выполненные")
                        }
                    } label: {
                        Label("Фильтр", systemImage: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Готово") {
                            withAnimation {
                                focusedField = nil
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        Text("Preview")
            .modifier(NavBarModifier(filter: .constant(.date), showCompleted: .constant(true)))
    }
}

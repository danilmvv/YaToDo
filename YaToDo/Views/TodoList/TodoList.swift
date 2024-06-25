//
//  TodoList.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import SwiftUI

struct TodoList: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        @Bindable var modelData = modelData
        
        NavigationStack {
            List {
                ForEach(modelData.filteredTodos) { todo in
                    TodoRow(todo: todo)
                        .swipeActions {
                            Button(role: .destructive) {
                                modelData.deleteTodo(todo.id)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                }
            }
            .animation(.default, value: modelData.filteredTodos)
            .navigationTitle("Мои Дела")
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Категория", selection: $modelData.filter) {
                            ForEach(ModelData.FilterCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Toggle(isOn: $modelData.showCompleted) {
                            Text("Показать выполненные")
                        }
                    } label: {
                        Label("Фильтр", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    TodoList()
        .environment(ModelData())
}

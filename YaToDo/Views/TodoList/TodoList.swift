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
            ZStack(alignment: .bottom) {
                List {
                    Section {
                        ForEach(modelData.filteredTodos) { todo in
                            TodoRow(todo: todo)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        withAnimation {
                                            modelData.toggleCompletion(todo)
                                        }
                                    } label: {
                                        Label("Complete", systemImage: "checkmark.circle.fill")
                                        
                                    }
                                    .tint(.green)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        modelData.deleteTodo(todo.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                    
                                    Button {
                                        print("Info")
                                    } label: {
                                        Label("Info", systemImage: "info.circle.fill")
                                    }
                                }
                        }
                    } header: {
                        Text("Выполнено – \(modelData.todos.filter { $0.isDone }.count)")
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
                            Label("Фильтр", systemImage: "ellipsis.circle")
                        }
                    }
                }
                
                Button {
                    // TODO: add new todo
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                }
            }
        }
    }
}

#Preview {
    TodoList()
        .environment(ModelData())
}

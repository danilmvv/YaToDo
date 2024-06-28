//
//  TodoList.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import SwiftUI

struct TodoList: View {
    @Environment(ModelData.self) var modelData
    
    @State private var showAddTodoView = false
    @State private var selectedTodo: TodoItem?
    
    var body: some View {
        @Bindable var modelData = modelData
        
        // TODO: NavigationSplitView
        NavigationStack {
            ZStack {
                if !modelData.todos.isEmpty {
                    List {
                        Section {
                            ForEach(modelData.filteredTodos) { todo in
                                TodoRow(todo: todo)
                                    .onTapGesture {
                                        selectedTodo = todo
                                    }
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
                                            selectedTodo = todo
                                        } label: {
                                            Label("Info", systemImage: "info.circle.fill")
                                        }
                                    }
                            }
                        } header: {
                            Text("Выполнено – \(modelData.todos.filter { $0.isDone }.count)")
                        }
                    }
                    .safeAreaPadding(.bottom, 44)
                    .animation(.default, value: modelData.filteredTodos)
                } else {
                    Text("Добавьте свои дела! :)")
                }
                
                VStack {
                    Spacer()
                    Button {
                        showAddTodoView = true
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
            .sheet(item: $selectedTodo) { todo in
                TodoEdit(viewModel: TodoEdit.ViewModel(todo: todo))
            }
            .sheet(isPresented: $showAddTodoView) {
                TodoEdit(viewModel: TodoEdit.ViewModel())
            }
        }
    }
}

#Preview {
    TodoList()
        .environment(ModelData())
}

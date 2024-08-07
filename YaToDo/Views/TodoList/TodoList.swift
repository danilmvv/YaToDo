//
//  TodoList.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import SwiftUI
import CocoaLumberjackSwift

struct TodoList: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State private var showAddTodoView = false
    @State private var selectedTodo: TodoItem?
    @State private var newTodoText: String = ""

    enum Field {
        case text
    }
    @FocusState private var focusedField: Field?

    var body: some View {
        @Bindable var modelData = modelData

        // iPad layout
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            NavigationSplitView {
                regularSection
                    .modifier(NavBarModifier(filter: $modelData.filter, showCompleted: $modelData.showCompleted))
                    .task {
                        Task {
                            await modelData.fetchTodoList()
                        }
                    }
                    .alert(isPresented: $modelData.isDirty) {
                        Alert(
                            title: Text("Sync Error"),
                            message: Text("Failed to sync with the server."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            } detail: {
                VStack {
                    Text("<- Выберите тудушку :)")

                    Spacer()

                    Image("harold")
                    Text("Когда заработал NavigationSplitView")

                    Spacer()
                }
            }
        } else {
            NavigationStack {
                compactSection
                    .modifier(NavBarModifier(filter: $modelData.filter, showCompleted: $modelData.showCompleted))
                    .task {
                        Task {
                            await modelData.fetchTodoList()
                        }
                    }
                    .alert(isPresented: $modelData.isDirty) {
                        Alert(
                            title: Text("Sync Error"),
                            message: Text("Failed to sync with the server."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            }
        }
    }

    // Compact UI
    @MainActor
    private var compactSection: some View {
        ZStack {
            if !modelData.todos.isEmpty {
                if !modelData.filteredTodos.isEmpty {
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
                                    .listRowInsets(EdgeInsets())
                            }

                            TextField("Новое", text: $newTodoText, axis: .vertical)
                                .focused($focusedField, equals: .text)
                                .padding(.leading)
                                .padding(.vertical, 8)
                                .onChange(of: focusedField) {
                                    if focusedField == nil && !newTodoText.isEmpty {
                                        modelData.addTodo(TodoItem(text: newTodoText))
                                        newTodoText = ""
                                    }
                                }
                        } header: {
                            Text("Выполнено – \(modelData.todos.filter { $0.isDone }.count)")
                        }
                    }
                    .safeAreaPadding(.bottom, 44)
                    .animation(.default, value: modelData.filteredTodos)
                } else {
                    Text("Все выполнено! :)")
                }

            } else {
                if modelData.isLoading {
                    ProgressView()
                } else {
                    Text("Добавьте свои дела! :)")
                }
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
                        .foregroundStyle(.accent)
                }
            }
        }
        .sheet(item: $selectedTodo) { todo in
            NavigationStack {
                TodoEdit(viewModel: TodoEdit.ViewModel(todo: todo))
            }
        }
        .sheet(isPresented: $showAddTodoView) {
            NavigationStack {
                TodoEdit(viewModel: TodoEdit.ViewModel())
            }
        }
        .onAppear {
            DDLogDebug("Loaded Compact UI")
        }
    }

    // Regular UI
    @MainActor
    private var regularSection: some View {
        ZStack {
            if !modelData.todos.isEmpty {
                if !modelData.filteredTodos.isEmpty {
                    List {
                        Section {
                            ForEach(modelData.filteredTodos) { todo in
                                NavigationLink {
                                    TodoEdit(viewModel: TodoEdit.ViewModel(todo: todo))
                                        .id(todo.id)
                                } label: {
                                    TodoRow(todo: todo)
                                }
                            }
                        } header: {
                            Text("Выполнено – \(modelData.todos.filter { $0.isDone }.count)")
                        }
                    }
                    .safeAreaPadding(.bottom, 44)
                    .animation(.default, value: modelData.filteredTodos)
                } else {
                    Text("Все выполнено :)")
                }
            } else {
                if modelData.isLoading {
                    ProgressView()
                } else {
                    Text("Добавьте свои дела! :)")
                }
            }

            VStack {
                Spacer()
                NavigationLink {
                    TodoEdit(viewModel: TodoEdit.ViewModel())
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                        .foregroundStyle(.accent)
                }
            }
        }
        .onAppear {
            DDLogDebug("Loaded Regular UI")
        }
    }
}

#Preview {
    TodoList()
        .environment(ModelData())
}

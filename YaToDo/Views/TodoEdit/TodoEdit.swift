//
//  TodoEdit.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import SwiftUI

struct TodoEdit: View {
    @Environment(ModelData.self) private var modelData
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: ViewModel
    
    @State private var showCalendar = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    todoTextField
                }
                
                Section {
                    priorityPicker
                    deadlineToggle
                    if showCalendar && viewModel.hasDeadline {
                        deadlineCalendar
                    }
                }
                .onChange(of: viewModel.hasDeadline) {
                    if !viewModel.hasDeadline {
                        showCalendar = false
                    }
                }
                
                /*
                 
                 В макете кнопка "удалить" – disabled, при создании новой тудушки,
                 но я ее убрал полностью, потому что мне кажется это более логичным.
                 
                 Но если убрать if, то кнопка будет как в макете.
                 
                 */
                
                if viewModel.todo != nil {
                    Section {
                        deleteButton
                    }
                }
            }
            .listSectionSpacing(16)
            .navigationTitle(viewModel.todo == nil ? "Новое дело" : "Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        modelData.addTodo(viewModel.createTodo())
                        dismiss()
                    } label: {
                        Text("Сохранить")
                            .fontWeight(.semibold)
                    }
                    .disabled(viewModel.todoText.isEmpty)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Отменить")
                    }
                }
            }
        }
    }
    
    private var todoTextField: some View {
        TextField("Что надо сделать?", text: $viewModel.todoText, axis: .vertical)
            .padding(.vertical, 5)
            .lineLimit(3...)
    }
    
    private var priorityPicker: some View {
        HStack {
            Text("Важность")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // TODO: Написать кастомный пикер
            Picker("", selection: $viewModel.todoPriority) {
                ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                    if priority == .important {
                        Text("‼")
                            .tag(priority)
                    } else if priority != .basic {
                        Image(systemName: priority.icon)
                            .tag(priority)
                    }
                    else {
                        Text("нет")
                            .tag(priority)
                    }
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
    
    private var deadlineToggle: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Сделать до")
                
                if viewModel.hasDeadline {
                    Button {
                        withAnimation {
                            showCalendar.toggle()
                        }
                    } label: {
                        Text(viewModel.todoDeadline.formattedDayMonthYear())
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .frame(height: 40)
            .animation(.default, value: viewModel.hasDeadline)
            
            Spacer()
            
            Toggle("Дедлайн", isOn: $viewModel.hasDeadline)
                .labelsHidden()
        }
    }
    
    private var deadlineCalendar: some View {
        VStack {
            DatePicker("Дедлайн", selection: $viewModel.todoDeadline, displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
        .padding(.top, -10)
        
    }
    
    private var deleteButton: some View {
        let canDelete = viewModel.todo != nil
        
        return Button {
            modelData.deleteTodo(viewModel.todoId)
            dismiss()
        } label: {
            Text("Удалить")
                .foregroundStyle(canDelete ? .red : .secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .center)
        .disabled(!canDelete)
    }
    
}

#Preview {
    TodoEdit(viewModel: TodoEdit.ViewModel(todo: TodoItem(text: "туду", deadline: Date())))
        .environment(ModelData())
}

#Preview {
    TodoEdit(viewModel: TodoEdit.ViewModel())
        .environment(ModelData())
}

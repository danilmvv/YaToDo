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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State var viewModel: ViewModel
    
    @State private var sheetHeight: CGFloat = .zero
    @State private var showCalendar = false
    @State private var showColorPicker = false
    
    enum Field {
        case text
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // portrait
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    Form {
                        Section {
                            todoTextField
                        }
                        
                        Section {
                            priorityPicker
                            colorPicker
                            deadlineToggle
                            if showCalendar && viewModel.hasDeadline {
                                deadlineCalendar
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
                    .animation(.default, value: focusedField)
                } else {
                    HStack(spacing: 0) {
                        Form {
                            Section {
                                todoTextField
                            }
                        }
                        
                        if focusedField == nil {
                            Form {
                                Section {
                                    priorityPicker
                                    colorPicker
                                    deadlineToggle
                                    if showCalendar && viewModel.hasDeadline {
                                        deadlineCalendar
                                    }
                                    
                                    if viewModel.todo != nil {
                                        deleteButton
                                    }
                                }
                            }
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                        }
                    }
                    .animation(.default, value: focusedField)
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
            .sheet(isPresented: $showColorPicker) {
                TodoColorPicker(color: $viewModel.todoColor)
                    .presentationDetents([.height(250)])
            }
        }
    }
    
    private var todoTextField: some View {
        ZStack(alignment: .trailing) {
            TextField("Что надо сделать?", text: $viewModel.todoText, axis: .vertical)
//                .padding(.vertical, 5)
                .lineLimit(3...)
                .focused($focusedField, equals: .text)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Rectangle()
                .fill(viewModel.todoColor)
                .frame(width: 8)
        }
        .listRowInsets(EdgeInsets())
    }
    
    private var priorityPicker: some View {
        HStack {
            Text("Важность")
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
    
    private var colorPicker: some View {
        HStack {
            Text("Цвет")
            
            Spacer()
            
            // TODO: Custom one
             TodoColorPickerLabel(color: viewModel.todoColor)
                .onTapGesture {
                    showColorPicker.toggle()
                }
        }
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
                            .foregroundStyle(.accent)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: 40)
            .animation(.default, value: viewModel.hasDeadline)
            
            Spacer()
            
            Toggle("Дедлайн", isOn: $viewModel.hasDeadline)
                .labelsHidden()
                .onChange(of: viewModel.hasDeadline) {
                    if !viewModel.hasDeadline {
                        showCalendar = false
                    }
                }
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
            
            // TODO: Confirmation modal
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

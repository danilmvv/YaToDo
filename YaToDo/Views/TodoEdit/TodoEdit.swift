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
            Form {
                Section {
                    textField
                }
                
                Section {
                    priorityPicker
                    deadlineToggle
                    if showCalendar && viewModel.hasDeadline {
                        deadlineCalendar
                    }
                }
            }
            .navigationTitle(viewModel.todo == nil ? "Новое дело" : "Редактировать дело")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var textField: some View {
        TextField("Что надо сделать?", text: $viewModel.todoText, axis: .vertical)
            .padding(.vertical, 5)
            .lineLimit(3...)
    }
    
    private var priorityPicker: some View {
        HStack {
            Text("Важность")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // TODO: Написать кастомный пикер
            Picker("", selection: $viewModel.priority) {
                ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                    if priority != .basic {
                        Image(systemName: priority.icon)
                            .tag(priority)
                    } else {
                        Text("нет")
                            .tag(priority)
                    }
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 5)
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
                        Text(viewModel.deadlineDate.formattedDayMonthYear())
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .frame(height: 42)
            .animation(.default, value: viewModel.hasDeadline)
            
            Spacer()
            
            Toggle("Дедлайн", isOn: $viewModel.hasDeadline)
                .labelsHidden()
        }
    }
    
    private var deadlineCalendar: some View {
        VStack {
            DatePicker("Дедлайн", selection: $viewModel.deadlineDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
        .padding(.top, -10)
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

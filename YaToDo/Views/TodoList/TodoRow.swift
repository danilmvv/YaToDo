//
//  TodoRow.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import SwiftUI

struct TodoRow: View {
    @Environment(ModelData.self) var modelData
    
    var todo: TodoItem
    var todoIndex: Int {
        modelData.todos.firstIndex(where: { $0.id == todo.id }) ?? 0
    }
    
    var isDone: Bool {
        if !modelData.todos.isEmpty {
            return modelData.todos[todoIndex].isDone
        }
        
        return false
    }
    
    var body: some View {
        HStack {
            // Done Button
            Button {
                withAnimation {
                    modelData.toggleCompletion(todo)
                }
            } label: {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(
                        isDone ? .green : (todo.priority == .important ? .red : .secondary)
                    )
                    .background(!isDone && todo.priority == .important ? .red.opacity(0.1) : .clear)
                    .clipShape(Circle())
                    .frame(maxWidth: 24, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .padding(.leading)
                    .padding(.trailing, 8)
                
            }
            .buttonStyle(.plain)
            .contentTransition(.symbolEffect(.replace))
            .sensoryFeedback(.impact(weight: .medium), trigger: todo.isDone)
            
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    
                    // Priority Label
                    if todo.priority != .basic && !isDone {
                        Image(
                            systemName: todo.priority == .low
                            ? "arrow.down"
                            : "exclamationmark.2"
                        )
                        .frame(minWidth: 16)
                        .foregroundColor(todo.priority == .low ? .secondary : .red)
                        .fontWeight(.bold)
                    }
                    
                    // Todo Text
                    Text(todo.text)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .foregroundStyle(todo.isDone ? .secondary : .primary)
                        .strikethrough(todo.isDone, color: .secondary)
                }
                
                // Deadline
                if let deadline = todo.deadline {
                    HStack(spacing: 2) {
                        Image(systemName: "calendar")
                        Text(deadline.formattedDayMonth())
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            Rectangle()
                .fill(Color.fromHexString(todo.color))
                .frame(width: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}



#Preview {
    TodoRow(todo: TodoItem(id: "123", text: "Купить что-то", priority: .important, deadline: Date()))
        .environment(ModelData())
}

#Preview {
    TodoList()
        .environment(ModelData())
}

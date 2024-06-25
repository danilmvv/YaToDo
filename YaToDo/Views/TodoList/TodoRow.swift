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

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    modelData.toggleCompletion(todo)
                }
            } label: {
                let isDone = modelData.todos[todoIndex].isDone
                Label("Toggle Done", systemImage: isDone ? "checkmark.circle.fill" : "circle")
                    .labelStyle(.iconOnly)
                    .foregroundColor(
                        isDone ? .green : (todo.priority == .important ? .red : .primary)
                    )
            }
            .buttonStyle(.plain)
            
            Text(todo.text)
                .foregroundStyle(todo.isDone ? .gray : .primary)
                .strikethrough(todo.isDone, color: .gray)
        }
    }
}

#Preview {
    TodoRow(todo: TodoItem(id: "123", text: "Купить что-то"))
        .environment(ModelData())
}

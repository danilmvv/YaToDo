//
//  ModelData.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import Foundation

@Observable
final class ModelData {
    private(set) var todos: [TodoItem] = [] // TODO: rewrite to dictionary
    
    enum FilterCategory: String, CaseIterable, Identifiable {
        case date = "Дата"
        case priority = "Важность"
        
        var id: FilterCategory { self }
    }
    
    var filter = FilterCategory.date
    var showCompleted = true
    
    var filteredTodos: [TodoItem] {
        let filtered = todos.filter { todo in
            showCompleted || !todo.isDone
        }
        
        switch filter {
        case .date:
            return filtered.sorted { $0.dateCreated > $1.dateCreated }
        case .priority:
            return filtered.sorted { $0.priority > $1.priority }
        }
    }
    
    // Моковые данные для теста UI и Observable
    init() {
        let currentDate = Date()
        let oneDay: TimeInterval = 86400
        
        todos = [
            TodoItem(
                id: "123",
                text: "Купить что-то",
                dateCreated: currentDate.addingTimeInterval(-1 * oneDay)
            ),
            TodoItem(
                text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно",
                dateCreated: currentDate.addingTimeInterval(-2 * oneDay)
            ),
            TodoItem(
                text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается многоточие бла бла бла бла бла",
                dateCreated: currentDate.addingTimeInterval(-3 * oneDay)
            ),
            TodoItem(
                text: "Купить что-то",
                priority: .low,
                dateCreated: currentDate.addingTimeInterval(-4 * oneDay)
            ),
            TodoItem(
                text: "Купить что-то",
                priority: .important,
                dateCreated: currentDate.addingTimeInterval(-5 * oneDay)
            ),
            TodoItem(
                text: "Купить что-то",
                isDone: true,
                dateCreated: currentDate.addingTimeInterval(-6 * oneDay)
            ),
            TodoItem(
                text: "Задание",
                deadline: currentDate.addingTimeInterval(86400),
                dateCreated: currentDate.addingTimeInterval(-7 * oneDay)
            )
        ]
    }
    
    func addTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        } else {
            todos.append(todo)
        }
    }
    
    func deleteTodo(_ id: String) {
        todos.removeAll { $0.id == id }
    }
    
    func toggleCompletion(_ todo: TodoItem) {
        guard let index = todos.firstIndex(of: todo) else { return }
        let updatedTodo = TodoItem(id: todo.id,
                                   text: todo.text,
                                   priority: todo.priority,
                                   color: todo.color,
                                   deadline: todo.deadline,
                                   isDone: !todo.isDone,
                                   dateCreated: todo.dateCreated,
                                   dateModified: Date())
        
        todos[index] = updatedTodo
    }
}

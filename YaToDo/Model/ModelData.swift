//
//  ModelData.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import Foundation

@Observable
final class ModelData {
    private(set) var todos: [TodoItem] = []
    
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
        todos = [
            TodoItem(text: "Купить что-то"),
            TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно"),
            TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается многоточие бла бла бла бла бла"),
            TodoItem(text: "Купить что-то", priority: .low),
            TodoItem(text: "Купить что-то", priority: .important),
            TodoItem(text: "Купить что-то", isDone: true),
            TodoItem(text: "Задание", deadline: Date().addingTimeInterval(86400)),
            
            TodoItem(id: "123", text: "Купить что-то"),
            TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно"),
            TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается многоточие бла бла бла бла бла"),
            TodoItem(text: "Купить что-то", priority: .low),
            TodoItem(text: "Купить что-то", priority: .important),
            TodoItem(text: "Купить что-то", isDone: true),
            TodoItem(text: "Задание", deadline: Date().addingTimeInterval(86400))
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
                                   deadline: todo.deadline,
                                   isDone: !todo.isDone,
                                   dateCreated: todo.dateCreated,
                                   dateModified: Date())
        
        todos[index] = updatedTodo
    }
}

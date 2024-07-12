//
//  ModelData.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import Foundation
import CocoaLumberjackSwift

@Observable
final class ModelData {
    private(set) var todos: [TodoItem] = [] // TODO: rewrite to dictionary

    private var customCategories: [TodoItem.Category] = []
    var categories: [TodoItem.Category] {
        TodoItem.Category.predefined + customCategories + [TodoItem.Category.other]
    }

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
            return filtered.sorted { $0.dateCreated < $1.dateCreated }
        case .priority:
            return filtered.sorted { $0.priority > $1.priority }
        }
    }

    // Моковые данные для теста UI и Observable
    init() {
        todos = MockData.todos
    }

    func addTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            DDLogDebug("Todo Edit")
        } else {
            todos.append(todo)
            DDLogDebug("Todo Added")
        }
    }

    func deleteTodo(_ id: String) {
        todos.removeAll { $0.id == id }
        DDLogDebug("Todo Deleted")
    }

    /// Обработка нажатия на кнопку выполнения
    func toggleCompletion(_ todo: TodoItem) {
        guard let index = todos.firstIndex(of: todo) else { return }
        let updatedTodo = TodoItem(id: todo.id,
                                   text: todo.text,
                                   priority: todo.priority,
                                   category: todo.category,
                                   color: todo.color,
                                   deadline: todo.deadline,
                                   isDone: !todo.isDone,
                                   dateCreated: todo.dateCreated,
                                   dateModified: Date())

        todos[index] = updatedTodo
        DDLogDebug("Todo Completion Toggled")
    }

    func addCustomCategory(_ category: TodoItem.Category) {
        customCategories.append(category)
        DDLogDebug("Category Added")
    }
}

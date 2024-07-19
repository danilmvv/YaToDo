//
//  ModelData.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import Foundation
import CocoaLumberjackSwift

@Observable
final class ModelData: @unchecked Sendable {
    private(set) var todos: [TodoItem] = []

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

    private let networkingService: NetworkingService
    var isLoading = false
    var error: Error?

    init(networkingService: NetworkingService = DefaultNetworkingService(token: "Andreth")) {
        //        todos = MockData.todos // Моковые данные для теста UI и Observable

        self.networkingService = networkingService
    }

    func fetchTodoList() async {
        isLoading = true
        error = nil
        do {
            let result = try await networkingService.fetchTodoList()
            todos = result
        } catch {
            self.error = error
            DDLogDebug("\(error)")
        }
        isLoading = false
    }

    func addTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            DDLogDebug("Todo Edit")

            Task {
                do {
                    let response = try await networkingService.updateTodoItem(todo)
                    DDLogDebug("\(response)")
                } catch {
                    self.error = error
                    DDLogDebug("\(error)")
                }
            }
        } else {
            todos.append(todo)
            DDLogDebug("Todo Added")

            Task {
                do {
                    let response = try await networkingService.addTodoItem(todo)
                    DDLogDebug("\(response)")
                } catch {
                    self.error = error
                    DDLogDebug("\(error)")
                }
            }
        }

    }

    func deleteTodo(_ id: String) {
        todos.removeAll { $0.id == id }
        DDLogDebug("Todo Deleted")

        Task {
            do {
                let responce = try await networkingService.deleteTodoItem(id: id)
                DDLogDebug("Delete: \(responce)")
            } catch {
                self.error = error
                DDLogDebug("\(error)")
            }
        }
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

        Task {
            do {
                let response = try await networkingService.updateTodoItem(updatedTodo)
                DDLogDebug("\(response)")
            } catch {
                self.error = error
                DDLogDebug("\(error)")
            }
        }
    }

    func addCustomCategory(_ category: TodoItem.Category) {
        customCategories.append(category)
        DDLogDebug("Category Added")
    }
}

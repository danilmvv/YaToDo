//
//  TodoEditViewModel.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 26/06/24.
//

import Foundation

extension TodoEdit {
    
    @Observable
    class ViewModel {
        var todo: TodoItem?
        var todoText: String
        var priority: TodoItem.Priority
        var hasDeadline: Bool
        var deadlineDate: Date
        var dateCreated: Date
        
        /// Инициализатор для добавления нового todo
        init() {
            self.todo = nil
            self.todoText = ""
            self.priority = .basic
            self.hasDeadline = false
            self.deadlineDate = Date().addingTimeInterval(86400)
            self.dateCreated = Date()
        }
        
        /// Инициализатор для изменения существующего todo
        init(todo: TodoItem) {
            self.todo = todo
            self.todoText = todo.text
            self.priority = todo.priority
            self.hasDeadline = todo.deadline != nil
            self.deadlineDate = todo.deadline ?? Date().addingTimeInterval(86400)
            self.dateCreated = todo.dateCreated
        }
        
        func createTodo() -> TodoItem {
            let newTodo = TodoItem(
                text: todoText,
                priority: priority,
                deadline: hasDeadline ? deadlineDate : nil,
                dateCreated: dateCreated,
                dateModified: Date()
            )
            
            return newTodo
        }
    }
}

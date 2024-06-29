//
//  TodoEditViewModel.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 26/06/24.
//

import Foundation
import SwiftUI

extension TodoEdit {
    
    @Observable
    class ViewModel {
        var todo: TodoItem?
        var todoId: String
        var todoText: String
        var todoPriority: TodoItem.Priority
        var todoColor: Color
        var hasDeadline: Bool
        var todoDeadline: Date
        var todoCompletion: Bool
        var todoDateCreated: Date
        
        /// Инициализатор для добавления нового todo
        init() {
            self.todo = nil
            self.todoId = UUID().uuidString
            self.todoText = ""
            self.todoPriority = .basic
            self.todoColor = Color.random()
            self.hasDeadline = false
            self.todoDeadline = Date().addingTimeInterval(86400)
            self.todoCompletion = false
            self.todoDateCreated = Date()
        }
        
        /// Инициализатор для изменения существующего todo
        init(todo: TodoItem) {
            self.todo = todo
            self.todoId = todo.id
            self.todoText = todo.text
            self.todoPriority = todo.priority
            self.todoColor = Color.fromHexString(todo.color)
            self.hasDeadline = todo.deadline != nil
            self.todoDeadline = todo.deadline ?? Date().addingTimeInterval(86400)
            self.todoCompletion = todo.isDone
            self.todoDateCreated = todo.dateCreated
        }
        
        func createTodo() -> TodoItem {
            let newTodo = TodoItem(
                id: todoId,
                text: todoText,
                priority: todoPriority,
                color: todoColor.toHexString(),
                deadline: hasDeadline ? todoDeadline : nil,
                isDone: todoCompletion,
                dateCreated: todoDateCreated,
                dateModified: Date()
            )
            
            return newTodo
        }
    }
}

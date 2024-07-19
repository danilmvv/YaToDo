//
//  NetworkingService.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 19/07/24.
//

import Foundation

protocol NetworkingService {
    func fetchTodoList() async throws -> [TodoItem]
    func updateTodoList(_ items: [TodoItem]) async throws -> [TodoItem]
    func fetchTodoItem(id: String) async throws -> TodoItem
    func addTodoItem(_ item: TodoItem) async throws -> TodoItem
    func updateTodoItem(_ item: TodoItem) async throws -> TodoItem
    func deleteTodoItem(id: String) async throws -> TodoItem
}

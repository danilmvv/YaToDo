//
//  FileCache.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 17/06/24.
//

import Foundation

enum FileCacheError: Error {
    case fileNotFound
    case saveFailed(Error)
    case loadFailed(Error)
    case parseFailed
}

final class FileCache {
    private(set) var todos: [TodoItem] = []
    
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
}

extension FileCache {
    func saveJSON(filename: String) throws {
        let fileURL = try getFileURL(filename)
        let jsonItems = todos.map({ $0.json })
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
            try data.write(to: fileURL)
        } catch {
            throw FileCacheError.saveFailed(error)
        }
    }
    
    func loadJSON(filename: String) throws {
        let fileURL = try getFileURL(filename)
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let jsonItems = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for json in jsonItems {
                    if let todoItem = TodoItem.parse(json: json) {
                        addTodo(todoItem)
                    } else {
                        throw FileCacheError.parseFailed
                    }
                }
            }
        } catch {
            throw FileCacheError.loadFailed(error)
        }
    }
    
    func saveCSV(filename: String) throws {
        let fileURL = try getFileURL(filename)
        let csvItems = todos.map({ $0.csv }).joined(separator: "\n")
        
        do {
            try csvItems.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            throw FileCacheError.saveFailed(error)
        }
    }
    
    func loadCSV(filename: String) throws {
        let fileURL = try getFileURL(filename)
        
        do {
            let data = try String(contentsOf: fileURL, encoding: .utf8)
            let csvLines = data.components(separatedBy: "\n")
            
            for line in csvLines {
                if let todoItem = TodoItem.parse(csv: line) {
                    addTodo(todoItem)
                }
            }
        } catch {
            throw FileCacheError.loadFailed(error)
        }
    }
    
    private func getFileURL(_ filename: String) throws -> URL {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.fileNotFound
        }
        return directory.appendingPathComponent(filename)
    }
}

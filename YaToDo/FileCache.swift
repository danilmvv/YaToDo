//
//  FileCache.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 17/06/24.
//

import Foundation


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
    
    func saveJSON(filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("fileURL not found")
            return
        }
        
        let jsonItems = todos.map({ $0.json })
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
            try data.write(to: fileURL)
        } catch {
            print("Save JSON faled: \(error)")
        }
    }
    
    func loadJSON(filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("fileURL not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let jsonItems = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for json in jsonItems {
                    if let todoItem = TodoItem.parse(json: json) {
                        addTodo(todoItem)
                    }
                }
            }
        } catch {
            print("Load JSON failed: \(error)")
        }
    }
    
    func saveCSV(filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("fileURL not found")
            return
        }
        
        let csvItems = todos.map({ $0.csv }).joined(separator: "\n")
        
        do {
            try csvItems.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Save CSV failed: \(error)")
        }
    }
    
    func loadCSV(filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("fileURL not found")
            return
        }
        
        do {
            let data = try String(contentsOf: fileURL, encoding: .utf8)
            let csvLines = data.components(separatedBy: "\n")
            
            for line in csvLines {
                if let todoItem = TodoItem.parse(csv: line) {
                    addTodo(todoItem)
                }
            }
        } catch {
            print("Load CSV failed: \(error)")
        }
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}

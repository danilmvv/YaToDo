//
//  TodoItem+CSV.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import Foundation

extension TodoItem {
    static func parse(csv: String) -> TodoItem? {
        var components = [String]()
        var currentComponent = ""
        var insideQuotes = false
        
        for char in csv {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(char)
            }
        }
        
        components.append(currentComponent)
        
        guard components.count == 7 else {
            return nil
        }
        
        let id = components[0]
        let text = parseCSVSeparator(component: components[1])
        guard !text.isEmpty else {
            return nil
        }
        
        let isDone = Bool(components[2]) ?? false
        let dateCreatedInterval = TimeInterval(components[3]) ?? Date().timeIntervalSince1970
        
        let dateCreated = Date(timeIntervalSince1970: dateCreatedInterval)
        
        let importanceString = components[4].isEmpty ? Priority.basic.rawValue : components[4]
        guard let priority = Priority(rawValue: importanceString) else {
            return nil
        }
        
        let deadlineInterval = TimeInterval(components[5])
        let deadline = deadlineInterval != nil ? Date(timeIntervalSince1970: deadlineInterval!) : nil
        
        let dateModifiedInterval = TimeInterval(components[6])
        let dateModified = dateModifiedInterval != nil ? Date(timeIntervalSince1970: dateModifiedInterval!) : nil
        
        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            dateCreated: dateCreated,
            dateModified: dateModified
        )
    }
    
    var csv: String {
        var csvString = "\(id),\(escapeCSVSeparator(component: text)),\(isDone),\(dateCreated.timeIntervalSince1970),"
        
        if priority != .basic {
            csvString += "\(priority.rawValue),"
        } else {
            csvString += ","
        }
        
        if let deadline = deadline {
            csvString += "\(deadline.timeIntervalSince1970),"
        } else {
            csvString += ","
        }
        
        if let dateModified = dateModified {
            csvString += "\(dateModified.timeIntervalSince1970)"
        }
        
        return csvString
    }
    
    private func escapeCSVSeparator(component: String) -> String {
        var escapedComponent = component
        
        // Оборачиваем в кавычки
        escapedComponent = escapedComponent.replacingOccurrences(of: "\"", with: "\"\"")
        if escapedComponent.contains(",") || escapedComponent.contains("\"") {
            escapedComponent = "\"\(escapedComponent)\""
        }
        
        return escapedComponent
    }
    
    private static func parseCSVSeparator(component: String) -> String {
        var parsedComponent = component
        
        // Убираем кавычки
        if parsedComponent.hasPrefix("\"") && parsedComponent.hasSuffix("\"") {
            parsedComponent.removeFirst()
            parsedComponent.removeLast()
        }
        
        parsedComponent = parsedComponent.replacingOccurrences(of: "\"\"", with: "\"")
        
        return parsedComponent
    }
}

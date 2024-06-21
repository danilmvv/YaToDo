//
//  TodoItem.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 17/06/24.
//

import Foundation

struct TodoItem: Identifiable, Equatable {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let dateCreated: Date
    let dateModified: Date?
    
    enum Priority: String, CaseIterable {
        case low
        case regular
        case high
    }
    
    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority = .regular,
        deadline: Date? = nil,
        isDone: Bool = false,
        dateCreated: Date = Date(),
        dateModified: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}


// MARK: JSON parsing
extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any] else {
            return nil
        }
        
        // Обязательные поля
        guard let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isDone = dict["isDone"] as? Bool,
              let dateCreatedInterval = dict["dateCreated"] as? TimeInterval
        else {
            return nil
        }
        
        let dateCreated = Date(timeIntervalSince1970: dateCreatedInterval)
        
        // Проверка опциональных полей
        let priorityString = dict["priority"] as? String ?? Priority.regular.rawValue
        guard let priority = Priority(rawValue: priorityString) else {
            return nil
        }
        
        let deadline: Date?
        if let deadlineInterval = dict["deadline"] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineInterval)
        } else {
            deadline = nil
        }
        
        let dateModified: Date?
        if let dateModifiedInterval = dict["dateModified"] as? TimeInterval {
            dateModified = Date(timeIntervalSince1970: dateModifiedInterval)
        } else {
            dateModified = nil
        }
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, dateCreated: dateCreated, dateModified: dateModified)
    }
    
    var json: Any {
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "dateCreated": dateCreated.timeIntervalSince1970
        ]
        
        if priority != .regular {
            dict["priority"] = priority.rawValue
        }
        
        if let deadline = deadline {
            dict["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let dateModified = dateModified {
            dict["dateModified"] = dateModified.timeIntervalSince1970
        }
        
        return dict
    }
}


// MARK: CSV parsing
extension TodoItem {
    static func parse(csv: String) -> TodoItem? {
        let components = csv.components(separatedBy: ",")
        
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
        
        let importanceString = components[4].isEmpty ? Priority.regular.rawValue : components[4]
        guard let priority = Priority(rawValue: importanceString) else {
            return nil
        }
        
        let deadlineInterval = TimeInterval(components[5])
        let deadline = deadlineInterval != nil ? Date(timeIntervalSince1970: deadlineInterval!) : nil
        
        let dateModifiedInterval = TimeInterval(components[6])
        let dateModified = dateModifiedInterval != nil ? Date(timeIntervalSince1970: dateModifiedInterval!) : nil
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, dateCreated: dateCreated, dateModified: dateModified)
    }
    
    var csv: String {        
        var csvString = "\(id),\(escapeCSVSeparator(component: text)),\(isDone),\(dateCreated.timeIntervalSince1970),"
        
        if priority != .regular {
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

//
//  TodoItemTests.swift
//  YaToDoTests
//
//  Created by Danil Masnaviev on 21/06/24.
//

import XCTest
@testable import YaToDo

final class TodoItemTests: XCTestCase {
    
    func testTodoItemInit() {
        let id = "123"
        let text = "Test"
        let priority = TodoItem.Priority.high
        let deadline = Date()
        let isDone = false
        let dateCreated = Date()
        let dateModified = Date()
        
        let todo = TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, dateCreated: dateCreated, dateModified: dateModified)
        
        XCTAssertEqual(todo.id, id)
        XCTAssertEqual(todo.text, text)
        XCTAssertEqual(todo.priority, priority)
        XCTAssertEqual(todo.deadline, deadline)
        XCTAssertEqual(todo.isDone, isDone)
        XCTAssertEqual(todo.dateCreated, dateCreated)
        XCTAssertEqual(todo.dateModified, dateModified)
    }
    
    func testTodoItemDefaultInit() {
        let todo = TodoItem(text: "Test")
        
        XCTAssertEqual(todo.priority, .regular)
        XCTAssertFalse(todo.isDone)
        XCTAssertNotNil(todo.dateCreated)
        XCTAssertNil(todo.dateModified)
    }
    
    // MARK: JSON Tests
    
    func testJSONSerialization() {
        let id = "123"
        let text = "Test"
        let priority = TodoItem.Priority.high
        let deadline = Date()
        let isDone = false
        let dateCreated = Date()
        let dateModified = Date()
        
        let todo = TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, dateCreated: dateCreated, dateModified: dateModified)
        
        let json = todo.json
        
        if let jsonDict = json as? [String: Any] {
            XCTAssertEqual(jsonDict["id"] as? String, todo.id)
            XCTAssertEqual(jsonDict["text"] as? String, todo.text)
            XCTAssertEqual(jsonDict["priority"] as? String, todo.priority.rawValue)
            XCTAssertEqual(jsonDict["deadline"] as? TimeInterval, todo.deadline?.timeIntervalSince1970)
            XCTAssertEqual(jsonDict["isDone"] as? Bool, todo.isDone)
            XCTAssertNotNil(jsonDict["dateCreated"])
            XCTAssertNotNil(jsonDict["dateModified"])
        } else {
            XCTFail("JSON Serialization Failed")
        }
    }
    
    func testJSONSerializationWithoutOptionalFields() {
        let todo = TodoItem(text: "Test")
        
        let json = todo.json
        
        if let dict = json as? [String: Any] {
            XCTAssertEqual(dict["id"] as? String, todo.id)
            XCTAssertEqual(dict["text"] as? String, todo.text)
            XCTAssertEqual(dict["isDone"] as? Bool, todo.isDone)
            XCTAssertNotNil(dict["dateCreated"])
        } else {
            XCTFail("JSON Serialization Without Optional Fields Failed")
        }
    }
    
    func testJSONDeserialization() {
        let json: [String: Any] = [
            "id": "123",
            "text": "Test",
            "priority": "high",
            "deadline": Date().timeIntervalSince1970,
            "isDone": false,
            "dateCreated": Date().timeIntervalSince1970,
            "dateModified": Date().timeIntervalSince1970,
        ]
        
        if let todo = TodoItem.parse(json: json) {
            XCTAssertEqual(todo.id, "123")
            XCTAssertEqual(todo.text, "Test")
            XCTAssertEqual(todo.priority, .high)
            XCTAssertNotNil(todo.deadline)
            XCTAssertFalse(todo.isDone)
            XCTAssertNotNil(todo.dateCreated)
            XCTAssertNotNil(todo.dateModified)
        } else {
            XCTFail("JSON Deserialization Failed")
        }
    }
    
    func testJSONDeserializationWithoutOptionalFields() {
        let json: [String: Any] = [
            "id": "123",
            "text": "Test",
            "isDone": false,
            "dateCreated": Date().timeIntervalSince1970,
        ]
        
        if let todo = TodoItem.parse(json: json) {
            XCTAssertEqual(todo.id, "123")
            XCTAssertEqual(todo.text, "Test")
            XCTAssertEqual(todo.priority, .regular)
            XCTAssertFalse(todo.isDone)
            XCTAssertNotNil(todo.dateCreated)
        } else {
            XCTFail("JSON Deserialization Without Optional Fields Failed")
        }
    }
    
    func testJSONDeserializationWithMissingRequiredFields() {
        let json: [String: Any] = [
            "priority": "high",
        ]

        let todoItem = TodoItem.parse(json: json)
        XCTAssertNil(todoItem, "JSON Deserialization With Missing Required Fields Failed")
    }
    
    // MARK: CSV Tests
    
    func testCSVSerialization() {
        let todoItem = TodoItem(
            id: "123",
            text: "Test",
            priority: .high,
            deadline: Date(timeIntervalSince1970: 1718971200),
            isDone: false,
            dateCreated: Date(timeIntervalSince1970: 1718971200),
            dateModified: Date(timeIntervalSince1970: 1718971200)
        )

        let csv = todoItem.csv

        let expectedCSV = "123,Test,false,1718971200.0,high,1718971200.0,1718971200.0"
        XCTAssertEqual(csv, expectedCSV)
    }
    
    func testCSVDeserialization() {
        let csv = "123,Test,false,1718971200.0,high,1718971200.0,1718971200.0"

        let todoItem = TodoItem.parse(csv: csv)

        XCTAssertEqual(todoItem?.id, "123")
        XCTAssertEqual(todoItem?.text, "Test")
        XCTAssertEqual(todoItem?.priority, .high)
        XCTAssertEqual(todoItem?.deadline?.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.isDone, false)
        XCTAssertEqual(todoItem?.dateCreated.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.dateModified?.timeIntervalSince1970, 1718971200.0)
    }
    
    func testCSVSerializationWithCommas() {
        let todoItem = TodoItem(
            id: "123",
            text: "Testing, separators, 123",
            priority: .high,
            deadline: Date(timeIntervalSince1970: 1718971200),
            isDone: false,
            dateCreated: Date(timeIntervalSince1970: 1718971200),
            dateModified: Date(timeIntervalSince1970: 1718971200)
        )

        let csv = todoItem.csv

        let expectedCSV = "123,\"Testing, separators, 123\",false,1718971200.0,high,1718971200.0,1718971200.0"
        XCTAssertEqual(csv, expectedCSV)
    }
    
    func testCSVDeserializationWithCommas() {
        let csv = "123,\"Testing, separators, 123\",false,1718971200.0,high,1718971200.0,1718971200.0"
        
        let todoItem = TodoItem.parse(csv: csv)
        
        XCTAssertEqual(todoItem?.id, "123")
        XCTAssertEqual(todoItem?.text, "Testing, separators, 123")
        XCTAssertEqual(todoItem?.priority, .high)
        XCTAssertEqual(todoItem?.deadline?.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.isDone, false)
        XCTAssertEqual(todoItem?.dateCreated.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.dateModified?.timeIntervalSince1970, 1718971200.0)
    }
    
    func testTodoItemFromInvalidCSVMissingFields() {
        let csv = "123,,false,,,,"

        let todoItem = TodoItem.parse(csv: csv)
        XCTAssertNil(todoItem, "CSV Deserialization With Missing Required Fields Failed")
    }
}

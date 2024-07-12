//
//  TodoItemJSONTests.swift
//  YaToDoTests
//
//  Created by Danil Masnaviev on 25/06/24.
//

import XCTest
@testable import YaToDo

final class TodoItemJSONTests: XCTestCase {

    func testJSONSerialization() {
        let id = "123"
        let text = "Test"
        let priority = TodoItem.Priority.important
        let deadline = Date()
        let isDone = false
        let dateCreated = Date()
        let dateModified = Date()

        let todo = TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            dateCreated: dateCreated,
            dateModified: dateModified
        )

        let json = todo.json

        if let jsonDict = json as? [String: Any] {
            XCTAssertEqual(jsonDict[TodoItem.CodingKeys.id.rawValue] as? String, todo.id)
            XCTAssertEqual(jsonDict[TodoItem.CodingKeys.text.rawValue] as? String, todo.text)
            XCTAssertEqual(jsonDict[TodoItem.CodingKeys.priority.rawValue] as? String, todo.priority.rawValue)
            XCTAssertEqual(
                jsonDict[TodoItem.CodingKeys.deadline.rawValue] as? TimeInterval, todo.deadline?.timeIntervalSince1970
            )
            XCTAssertEqual(jsonDict[TodoItem.CodingKeys.isDone.rawValue] as? Bool, todo.isDone)
            XCTAssertNotNil(jsonDict[TodoItem.CodingKeys.dateCreated.rawValue])
            XCTAssertNotNil(jsonDict[TodoItem.CodingKeys.dateModified.rawValue])
        } else {
            XCTFail("JSON Serialization Failed")
        }
    }

    func testJSONSerializationWithoutOptionalFields() {
        let todo = TodoItem(text: "Test")

        let json = todo.json

        if let dict = json as? [String: Any] {
            XCTAssertEqual(dict[TodoItem.CodingKeys.id.rawValue] as? String, todo.id)
            XCTAssertEqual(dict[TodoItem.CodingKeys.text.rawValue] as? String, todo.text)
            XCTAssertEqual(dict[TodoItem.CodingKeys.isDone.rawValue] as? Bool, todo.isDone)
            XCTAssertNotNil(dict[TodoItem.CodingKeys.dateCreated.rawValue])
        } else {
            XCTFail("JSON Serialization Without Optional Fields Failed")
        }
    }

    func testJSONDeserialization() {
        let json: [String: Any] = [
            TodoItem.CodingKeys.id.rawValue: "123",
            TodoItem.CodingKeys.text.rawValue: "Test",
            TodoItem.CodingKeys.priority.rawValue: "important",
            TodoItem.CodingKeys.deadline.rawValue: Date().timeIntervalSince1970,
            TodoItem.CodingKeys.isDone.rawValue: false,
            TodoItem.CodingKeys.dateCreated.rawValue: Date().timeIntervalSince1970,
            TodoItem.CodingKeys.dateModified.rawValue: Date().timeIntervalSince1970
        ]

        if let todo = TodoItem.parse(json: json) {
            XCTAssertEqual(todo.id, "123")
            XCTAssertEqual(todo.text, "Test")
            XCTAssertEqual(todo.priority, .important)
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
            TodoItem.CodingKeys.id.rawValue: "123",
            TodoItem.CodingKeys.text.rawValue: "Test",
            TodoItem.CodingKeys.isDone.rawValue: false,
            TodoItem.CodingKeys.dateCreated.rawValue: Date().timeIntervalSince1970
        ]

        if let todo = TodoItem.parse(json: json) {
            XCTAssertEqual(todo.id, "123")
            XCTAssertEqual(todo.text, "Test")
            XCTAssertEqual(todo.priority, .basic)
            XCTAssertFalse(todo.isDone)
            XCTAssertNotNil(todo.dateCreated)
        } else {
            XCTFail("JSON Deserialization Without Optional Fields Failed")
        }
    }

    func testJSONDeserializationWithMissingRequiredFields() {
        let json: [String: Any] = [
            TodoItem.CodingKeys.priority.rawValue: "high"
        ]

        let todoItem = TodoItem.parse(json: json)
        XCTAssertNil(todoItem, "JSON Deserialization With Missing Required Fields Failed")
    }

}

//
//  DataTaskTests.swift
//  YaToDoTests
//
//  Created by Danil Masnaviev on 13/07/24.
//

import XCTest
@testable import YaToDo

final class DataTaskTests: XCTestCase {
    func testSuccessfulDataTask() async throws {
        let session = URLSession.shared
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let request = URLRequest(url: url)

        let (data, response) = try await session.dataTask(for: request)

        XCTAssertNotNil(data)
        XCTAssertNotNil(response)

        /*
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Headers: \(httpResponse.allHeaderFields)")
        }

        if let responseData = String(data: data, encoding: .utf8) {
            print("Response Data: \(responseData)")
        } else {
            XCTFail("Failed to decode response data.")
        }
         */
    }

    func testCancellation() async {
        let session = URLSession.shared
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let request = URLRequest(url: url)

        let task = Task {
            do {
                _ = try await session.dataTask(for: request)
                XCTFail("Not cancelled")
            } catch {
                XCTAssertTrue((error as? CancellationError) != nil)
            }
        }

        task.cancel()

        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            XCTFail("Cancellation failed")
        }
    }
}

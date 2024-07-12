//
//  URLSession+dataTask.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 13/07/24.
//

import Foundation

actor DataTaskManager {
    var task: URLSessionDataTask?
    var isCancelled: Bool = false

    func cancel() {
        isCancelled = true
        task?.cancel()
    }

    func set(_ dataTask: URLSessionDataTask) {
        task = dataTask
    }
}

extension URLSession {
    func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
        let dataTaskManager = DataTaskManager()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let dataTask = self.dataTask(with: request) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        continuation.resume(throwing: URLError(.unknown))
                    }
                }

                Task {
                    await dataTaskManager.set(dataTask)

                    if await dataTaskManager.isCancelled {
                        continuation.resume(throwing: CancellationError())
                    } else {
                        dataTask.resume()
                    }
                }
            }
        } onCancel: {
            Task {
                await dataTaskManager.cancel()
            }
        }
    }
}

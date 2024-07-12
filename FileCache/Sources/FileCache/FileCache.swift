// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum FileCacheError: Error {
    case fileNotFound
    case saveFailed(Error)
    case loadFailed(Error)
    case parseFailed
}

public final class FileCache<T: Cacheable> {
    private(set) var items: [T] = []

    func addItem(_ item: T) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    func deleteTodo(_ id: String) {
        items.removeAll { $0.id == id }
    }

    func saveJSON(filename: String) throws {
        let fileURL = try getFileURL(filename)
        let jsonItems = items.map({ $0.json })

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
                    if let item = T.parse(json: json) {
                        addItem(item)
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
        let csvItems = items.map({ $0.csv }).joined(separator: "\n")

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
                if let item = T.parse(csv: line) {
                    addItem(item)
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

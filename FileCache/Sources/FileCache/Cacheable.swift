//
//  Cacheable.swift
//
//
//  Created by Danil Masnaviev on 12/07/24.
//

import Foundation

public protocol Cacheable {
    var id: String { get }
    var json: Any { get }
    var csv: String { get }

    static func parse(json: Any) -> Self?
    static func parse(csv: String) -> Self?
}

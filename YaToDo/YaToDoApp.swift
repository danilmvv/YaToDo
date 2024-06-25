//
//  YaToDoApp.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 17/06/24.
//

import SwiftUI

@main
struct YaToDoApp: App {
    @State private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}

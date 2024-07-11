//
//  YaToDoApp.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 17/06/24.
//

import SwiftUI
import CocoaLumberjackSwift

@main
struct YaToDoApp: App {
    @State private var modelData = ModelData()
    
    init() {
        setUpLoggers()
        DDLogInfo("Запуск")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
    
    private func setUpLoggers() {
        DDLog.add(DDOSLogger.sharedInstance)
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}

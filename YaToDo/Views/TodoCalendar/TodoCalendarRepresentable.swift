//
//  TodoCalendar.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import SwiftUI

struct TodoCalendarRepresentable: UIViewControllerRepresentable {
    var modelData: ModelData
    
    func makeUIViewController(context: Context) -> TodoCalendarViewController {
        let viewController = TodoCalendarViewController()
        viewController.todos = modelData.todos
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: TodoCalendarViewController, context: Context) {
        print(#function)
        uiViewController.todos = modelData.todos
    }
}

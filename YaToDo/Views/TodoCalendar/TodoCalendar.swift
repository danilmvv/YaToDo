//
//  TodoCalendar.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import SwiftUI

struct TodoCalendar: UIViewControllerRepresentable {
    var todos: [TodoItem]
    
    func makeUIViewController(context: Context) -> TodoCalendarViewController {
        let viewController = TodoCalendarViewController()
        viewController.todos = todos
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: TodoCalendarViewController, context: Context) {
        uiViewController.todos = todos
    }
}

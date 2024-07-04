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
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: TodoCalendarViewController, context: Context) {
        uiViewController.todos = modelData.todos
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, TodoListViewControllerDelegate {
        var parent: TodoCalendarRepresentable

        init(_ parent: TodoCalendarRepresentable) {
            self.parent = parent
        }

        func didMarkTodoAsDone(_ todo: TodoItem) {
            parent.modelData.toggleCompletion(todo)
        }
    }
    
}

//
//  TodoCalendar.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import SwiftUI

struct TodoCalendar: View {
    @Environment(ModelData.self) var modelData
    @State private var showAddTodoView = false
    
    var body: some View {
        ZStack {
            TodoCalendarRepresentable(todos: modelData.todos)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button {
                    showAddTodoView = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                        .foregroundStyle(.accent)
                }
            }
        }
        .sheet(isPresented: $showAddTodoView) {
            TodoEdit(viewModel: TodoEdit.ViewModel())
        }
        
    }
}

#Preview {
    TodoCalendar()
}

//
//  TodoCalendar.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import SwiftUI

struct TodoCalendar: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State private var showAddTodoView = false
    
    var body: some View {
        ZStack {
            TodoCalendarRepresentable(modelData: modelData)
                .ignoresSafeArea()
            
            // not showing on iPads
            if !(horizontalSizeClass == .regular && verticalSizeClass == .regular) {
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
        }
        .sheet(isPresented: $showAddTodoView) {
            NavigationStack {
                TodoEdit(viewModel: TodoEdit.ViewModel())
            }
        }
        
    }
}

#Preview {
    TodoCalendar()
        .environment(ModelData())
}

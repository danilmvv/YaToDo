//
//  TodoColorPickerLabel.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 28/06/24.
//

import SwiftUI

struct TodoColorPickerLabel: View {
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                .red,
                                .yellow,
                                .green,
                                .cyan,
                                .blue,
                                .purple,
                                .red
                            ]
                        ),
                        
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    ),
                    
                    lineWidth: 3
                )
                .frame(width: 28, height: 28)
            
            Circle()
                .fill(color)
                .frame(width: 18)
        }
    }
}

#Preview {
    TodoColorPickerLabel(color: Color.random())
}

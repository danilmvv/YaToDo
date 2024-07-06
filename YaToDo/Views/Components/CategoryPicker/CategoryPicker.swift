//
//  CategoryPicker.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 06/07/24.
//

import SwiftUI

struct CategoryPicker: View {
    @Environment(ModelData.self) var modelData
    @Binding var viewModel: TodoEdit.ViewModel
    
    @State private var isAddingCategory = false
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    ForEach(modelData.categories, id: \.self) { category in
                        HStack {
                            Circle().fill(category.color)
                                .frame(width: 10)
                            Text(category.name)
                            Spacer()
                            if viewModel.todoCategory == category {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.todoCategory = category
                        }
                    }
                }
                
                if isAddingCategory {
                    Section {
                        TextField("Название категории", text: $viewModel.customCategoryName)
                        
                        ColorPicker("Цвет", selection: $viewModel.customCategoryColor)
                    } header: {
                        if showAlert {
                            Text("Заполните название")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                Button {
                    withAnimation {
                        if isAddingCategory {
                            if !viewModel.customCategoryName.isEmpty {
                                let category = TodoItem.Category(
                                    id: UUID().uuidString,
                                    name: viewModel.customCategoryName,
                                    color: viewModel.customCategoryColor
                                )
                                
                                modelData.addCustomCategory(category)
                                
                                viewModel.todoCategory = category
                                viewModel.customCategoryName = ""
                                viewModel.customCategoryColor = .random()
                                isAddingCategory = false
                            } else {
                                showAlert = true
                            }
                        } else {
                            withAnimation(.easeOut) {
                                isAddingCategory = true
                            }
                        }
                    }
                } label: {
                    Text(isAddingCategory ? "Сохранить" : "Добавить новую")
                        .foregroundStyle(isAddingCategory ? .white : .accent)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(isAddingCategory ? Color.accent : Color.white)
            }
        }
        .navigationTitle("Выберите категорию")
    }
}

#Preview {
    CategoryPicker(viewModel: .constant(TodoEdit.ViewModel()))
        .environment(ModelData())
}

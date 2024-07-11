//
//  TodoColorPicker.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 29/06/24.
//

import SwiftUI

struct TodoColorPicker: View {
    @Binding var color: Color
    @State private var selectedHue: Double = 0.0
    @State private var brightness: Double = 1.0

    @Environment(\.dismiss) var dismiss

    var currentColor: Color {
        Color(hue: selectedHue, saturation: 1.0, brightness: brightness)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Выберите цвет:")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ColorSpectrum(selectedHue: $selectedHue)
                    .frame(height: 40)
                    .cornerRadius(10)
                    .padding(.horizontal)

                Slider(value: $brightness, in: 0.0...1.0)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ZStack {
                        Rectangle()
                            .fill(currentColor)
                            .cornerRadius(8)

                        Text(currentColor.toHexString())
                            .foregroundStyle(currentColor.isDark ? .white : .black)
                            .padding(8)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .onAppear {
                updateState(from: color)
            }
            .onChange(of: color) { _, newColor in
                updateState(from: newColor)
            }
            .onChange(of: selectedHue) {
                updateColor()
            }
            .onChange(of: brightness) {
                updateColor()
            }

            // TODO: Optimize updates
        }
    }

    private func updateState(from color: Color) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.selectedHue = Double(hue)
        self.brightness = Double(brightness)
    }

    private func updateColor() {
        color = currentColor
    }
}

struct ColorSpectrum: View {
    @Binding var selectedHue: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
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
                    startPoint: .leading,
                    endPoint: .trailing
                )

                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .position(x: CGFloat(self.selectedHue) * geometry.size.width, y: geometry.size.height / 2)
            }
            .gesture(DragGesture(minimumDistance: 0).onChanged { value in
                let location = value.location.x / geometry.size.width
                self.selectedHue = Double(location).bounds(0.0...1.0)
            })
        }
    }
}

extension Double {
    func bounds(_ bounds: ClosedRange<Double>) -> Double {
        return min(max(self, bounds.lowerBound), bounds.upperBound)
    }
}

#Preview {
    TodoColorPicker(color: .constant(.blue))
}

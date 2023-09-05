//
//  GaugeView.swift
//  GaugeView
//
//  Created by Amir on 9/5/23.
//

import SwiftUI

struct GaugeView: View {
    let numberOfTicks: Int
    let rectangleWidth: CGFloat = 5
    let rectangleHeight: CGFloat = 40
    let circleRadius: CGFloat = 200
    let startAngle: Double  // in degrees
    let stopAngle: Double   // in degrees
    let minValue: Double
    let maxValue: Double
    let selectedValue: Double
    let animationDuration: Double
    let arrowTickExtraLength: CGFloat = 5
    
    @State private var currentValue: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Ticks
                ForEach(0..<numberOfTicks) { index in
                    let fraction = Double(index) / Double(numberOfTicks - 1)
                    let angle = startAngle + fraction * (stopAngle - startAngle)
                    let currentAngleValue = minValue + fraction * (maxValue - minValue)

                    Rectangle()
                        .fill(backgroundColor(for: currentAngleValue))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .offset(y: -circleRadius + rectangleHeight/2)
                        .rotationEffect(.degrees(angle), anchor: .center)
                }

                // Overlay Tick pointing to current Value
                let fractionForSelectedValue = (currentValue - minValue) / (maxValue - minValue)
                let selectedValueAngle = startAngle + fractionForSelectedValue * (stopAngle - startAngle)
                Rectangle()
                       .fill(Color.red)
                       .cornerRadius(rectangleWidth / 2.0)
                       .frame(width: rectangleWidth, height: rectangleHeight + arrowTickExtraLength)
                       .offset(y: -circleRadius - (arrowTickExtraLength / 2) + rectangleHeight/2)
                       .rotationEffect(.degrees(selectedValueAngle), anchor: .center)
                // Value text
                    VStack(spacing: 20) {
                        Text("\(Int(currentValue))")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.black)

                        Text(evaluationForScore(value: currentValue))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                startCountingAnimation()
            }
        }
    }
    func evaluationForScore(value: Double) -> String {
        switch value {
        case 0..<25:
            return "Poor"
        case 25..<50:
            return "Fair"
        case 50..<75:
            return "Good"
        default:
            return "Excellent"
        }
    }
    func startCountingAnimation() {
        let increment = selectedValue / (animationDuration * 60) // 60 updates per second
        Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { timer in
            if currentValue < selectedValue {
                currentValue += increment
            } else {
                currentValue = selectedValue
                timer.invalidate()
            }
        }
    }

    // Function to calculate the background color for each rectangle based on the currentValue
    func backgroundColor(for value: Double) -> Color {
        if value > currentValue {
            return Color.gray
        }
        let fraction = (value - minValue) / (maxValue - minValue)
            
            var redComponent: Double = 1.0
            var greenComponent: Double = 0.0
            var blueComponent: Double = 0.0
            
            if fraction <= 0.25 { // Red to Orange
                greenComponent = fraction * 4
            } else if fraction <= 0.5 { // Orange to Yellow
                greenComponent = 1.0
                redComponent = 1.0 - (fraction - 0.25) * 4
            } else if fraction <= 0.75 { // Yellow to Green
                greenComponent = 1.0
                redComponent = 0.0
                blueComponent = (fraction - 0.5) * 4 - 1.0
            } else { // Pure Green
                greenComponent = 1.0
                redComponent = 0.0
                blueComponent = 0.0
            }
            
            return Color(red: redComponent, green: greenComponent, blue: blueComponent)
    }
}

struct GaugeView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeView(
            numberOfTicks: 40,
            startAngle: -110,
            stopAngle: 110,
            minValue: 0,
            maxValue: 100,
            selectedValue: 75,
            animationDuration: 2.0
        )
        .frame(width: 500, height: 500)
    }
}

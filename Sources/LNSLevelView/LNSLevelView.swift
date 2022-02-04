//
//  LNSBatteryLevel.swift
//  LNSBatteryLevel
//
//  Created by Mark Alldritt on 2021-02-14.
//

import SwiftUI


fileprivate extension CGColor {

    var rgbComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.components!

        switch components.count == 2 {
        case true : return (r: components[0], g: components[0], b: components[0], a: components[1])
        case false: return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }

    static func interpolate(from fromColor: CGColor, to toColor: CGColor, with progress: CGFloat) -> CGColor {
        let fromComponents = fromColor.rgbComponents
        let toComponents = toColor.rgbComponents

        let r = (1 - progress) * fromComponents.r + progress * toComponents.r
        let g = (1 - progress) * fromComponents.g + progress * toComponents.g
        let b = (1 - progress) * fromComponents.b + progress * toComponents.b
        let a = (1 - progress) * fromComponents.a + progress * toComponents.a

        return CGColor(red: r, green: g, blue: b, alpha: a)
    }
}


public struct LNSLevelView: View {
    @Binding public var value: CGFloat
    public let maxValue: CGFloat
    public let backgroundColor: Gradient // background gradient
    public var foregroundColor: Gradient // value bar gradient
    public var animationDuration: TimeInterval
    
    public init(value: Binding<CGFloat>,
                maxValue: CGFloat,
                backgroundColor: Gradient = .init(colors: [Color.green.opacity(0.2)]),
                foregroundColor: Gradient = .init(colors: [Color.green]),
                animationDuration: TimeInterval = 1) {
        self._value = value
        self.maxValue = maxValue
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.animationDuration = animationDuration
    }

    @inline(__always)
    private var percentage: CGFloat {
        return max(0, min(value, maxValue)) / maxValue
    }
    
    @inline(__always)
    private func level(height: CGFloat) -> CGFloat {
        return height * percentage
    }
    
    private var barColor: Color {
        //  Find the two segments and calculate the interpolated color...  The assumption
        //  is that location increases with each stop.
        let percentage = self.percentage

        for i in 1..<foregroundColor.stops.count {
            if percentage >= foregroundColor.stops[i - 1].location &&
                percentage <= foregroundColor.stops[i].location {
                let fromColor = foregroundColor.stops[i - 1].color.cgColor
                let toColor = foregroundColor.stops[i].color.cgColor
                let baseValue = foregroundColor.stops[i - 1].location

                let delta = foregroundColor.stops[i].location - foregroundColor.stops[i - 1].location
                let v = (percentage - baseValue) / delta
                
                return Color(CGColor.interpolate(from: fromColor!, to: toColor!, with: v))
            }
        }
        
        return foregroundColor.stops[0].color
    }
    
    public var body: some View {
        GeometryReader { geometryReader in
            let level = level(height: geometryReader.size.height)
            let backgroundColor = LinearGradient(gradient: backgroundColor, startPoint: .bottom, endPoint: .top)
            let barColor = barColor

            Rectangle()
                .fill(backgroundColor)
                .overlay(
                    Rectangle()
                        .fill(barColor)
                        .frame(height: level),
                    alignment: .bottom
                )
                .overlay(
                    Rectangle()
                        .stroke(barColor, lineWidth: 0.5)
                )
                .animation(Animation.easeInOut(duration: animationDuration), value: value)
        }
    }
}



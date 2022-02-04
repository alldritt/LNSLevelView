//
//  LNSBatteryLevel.swift
//  LNSBatteryLevel
//
//  Created by Mark Alldritt on 2021-02-14.
//

import SwiftUI


fileprivate extension CGColor {
    /// The RGBA components associated with a `UIColor` instance.
    var rgbComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.components!

        switch components.count == 2 {
        case true : return (r: components[0], g: components[0], b: components[0], a: components[1])
        case false: return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }

    /**
     Returns a `UIColor` by interpolating between two other `UIColor`s.
     - Parameter fromColor: The `UIColor` to interpolate from
     - Parameter toColor:   The `UIColor` to interpolate to (e.g. when fully interpolated)
     - Parameter progress:  The interpolation progess; must be a `CGFloat` from 0 to 1
     - Returns: The interpolated `UIColor` for the given progress point
     */
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
    public @Binding var value: CGFloat
    public let maxValue: CGFloat
    public var backgroundColor = Gradient(colors: [Color.green.opacity(0.2)]) // default background gradient
    public var foregroundColor = Gradient(colors: [Color.green]) // default value bar gradient
    public var animationDuration = TimeInterval(1) // default animation: 1s

    private func level(value: CGFloat, height: CGFloat) -> CGFloat {
        let percentage = max(0, min(value, maxValue)) / maxValue
        return height * percentage
    }
    
    private var barColor: Color {
        //  Find the two segments and calculate the interpolated color...  The assumption
        //  is that location increases with each stop.
        var baseValue = foregroundColor.stops[0].location
        
        for i in 1..<foregroundColor.stops.count {
            if value >= foregroundColor.stops[i - 1].location &&
                value <= foregroundColor.stops[i].location {
                let fromColor = foregroundColor.stops[i - 1].color.cgColor
                let toColor = foregroundColor.stops[i].color.cgColor
                
                let delta = foregroundColor.stops[i].location - foregroundColor.stops[i - 1].location
                let v = (value - baseValue) / delta
                
                return Color(CGColor.interpolate(from: fromColor!, to: toColor!, with: v))
            }
            
            baseValue = foregroundColor.stops[i].location
        }
        
        return foregroundColor.stops[0].color
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometryReader in
                let level = level(value: value,
                                  height: geometryReader.size.height)
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
}

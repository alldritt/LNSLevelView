//
//  LNSBatteryLevel.swift
//  LNSBatteryLevel
//
//  Created by Mark Alldritt on 2021-02-14.
//

import SwiftUI
import LNSSwiftUIExtras


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

        let i = foregroundColor.stops.lastIndex(where: { stop in
            percentage >= stop.location
        }) ?? (percentage == 0 ? foregroundColor.stops.startIndex : foregroundColor.stops.endIndex - 1)

        let fromColor = foregroundColor.stops[i].color
        if i == foregroundColor.stops.endIndex - 1 || fromColor == foregroundColor.stops[i + 1].color {
            return fromColor
        }
        else {
            let toColor = foregroundColor.stops[i + 1].color
            let baseValue = foregroundColor.stops[i].location
            let delta = foregroundColor.stops[i + 1].location - baseValue
            let v = (percentage - baseValue) / delta
            
            return fromColor.interpolate(to: toColor, with: v)
        }
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



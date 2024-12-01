# LNSLevelView

A SwiftUI quality level view (vertical bar)

## Installation

Add the LNSLevelView swift package to your project:

  `https://github.com/alldritt/LNSLevelView.git`

## Usage

LNSLevelView is a view you can combine with other SwiftUI views to add a value qiality indicator to your application:


```
import SwiftUI
import LNSLevelView
import LNSSwiftUIExtras


struct ContentView: View {
    @State var level: CGFloat: 20 // 0..100
    
    var impedanceGradient: Gradient {
        Gradient(stops: [.init(color: Color(uiColor: .green), location: 0),
                         .init(color: Color(uiColor: .green), location: 0.5),
                         .init(color: Color(uiColor: .orange), location: 0.7),
                         .init(color: Color(uiColor: .red), location: 1)])
    }

    var body: some View {
        VStack {
            LevelView(value: $level,
                      maxValue: 100,
                      backgroundColor: impedanceGradient.opacity(0.15),
                      foregroundColor: impedanceGradient)
                .frame(width: 20, height: 100)
                .padding()
            Slider(value: $level, in: 0...100)
                .frame(width: 200)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


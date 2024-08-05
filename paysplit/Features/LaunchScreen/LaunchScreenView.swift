//
//  LaunchScreenView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import SwiftUI

struct LaunchScreenView: View {
    @Binding
    var showHomeScreen: Bool

    let sizeSplitText: CGFloat = 140
    let sizeSplitRect: CGFloat = 110
    let sizePay: CGFloat = 140

    @State private var showSplitImage = false
    @State private var showLineImage = false
    @State private var paysplitRectangleProgress: CGFloat = 0.0
    @State private var paysplitScale: CGFloat = 1

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            GeometryReader { reader in
                if showSplitImage {
                    Image("appIconSplit")
                        .resizable()
                        .frame(width: sizeSplitText, height: sizeSplitText)
                        .position(
                            x: (reader.size.width/2) + 75,
                            y: (reader.size.height/2) - 12
                        )
                        .transition(.offset(x: -130))
                }

                if showLineImage {
                    Image("appIconLines")
                        .resizable()
                        .frame(width: 107.5, height: 90)
                        .position(
                            x: (reader.size.width/2) + 75,
                            y: (reader.size.height/2) - 12
                        )
                }

                PaysplitRectangle()
                    .trim(from: 0, to: paysplitRectangleProgress)
                    .stroke(
                        .black,
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .frame(width: sizeSplitRect, height: sizeSplitRect)
                    .animation(.easeInOut(duration: 2), value: paysplitRectangleProgress)
                    .position(
                        x: (reader.size.width/2) + 48,
                        y: (reader.size.height/2) - 12
                    )

                Image("appIconPay")
                    .resizable()
                    .frame(width: sizePay, height: sizePay)
                    .position(
                        x: (reader.size.width/2) - 60,
                        y: (reader.size.height/2) - 13
                    )
            }
        }
        .scaleEffect(paysplitScale)
        .onReceive(timer) { _ in
            if paysplitRectangleProgress < 1.0 {
                paysplitRectangleProgress += 0.1
            } else {
                timer.upstream.connect().cancel()

                withAnimation(
                    .easeInOut(duration: 1)
                ) {
                    showLineImage = true
                }

                withAnimation(
                    .spring(
                        duration: 1,
                        bounce: 0.4
                    )
                ) {
                    showSplitImage = true
                }

                withAnimation(
                    .easeOut(duration: 1)
                    .delay(1)
                ) {
                    paysplitScale = 0.8
                }

                withAnimation(
                    .easeInOut(duration: 1)
                    .delay(2)
                ) {
                    paysplitScale = 50
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 1)) {
                        showHomeScreen = true
                    }
                }
            }
        }
        .statusBarHidden()
    }
}

struct PaysplitRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        return path
    }
}

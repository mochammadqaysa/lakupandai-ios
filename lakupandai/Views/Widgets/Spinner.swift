//
//  Spinner.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 03/01/24.
//

import SwiftUI

struct Spinner: View {
    let trimFrom: CGFloat = 0
    let trimTo: CGFloat = 0.65
    @State private var animateStrokeStart = false
    @State private var animateStrokeEnd = true
    @State private var isRotating = true
    var body: some View {
        HStack {
            GeometryReader { geometry in
                self.makeView(geometry)
            }
        }
    }

    func makeView(_ geometry: GeometryProxy) -> some View {
        let thickness: CGFloat = geometry.size.height * 3 / 46
        return ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: thickness))
                .foregroundColor(Color("colorPrimary"))
            Circle()
                .trim(from: animateStrokeStart ? 0 : 0.1,
                      to: animateStrokeEnd ? 0.01 : 0.95)
                .stroke(style: StrokeStyle(lineWidth: thickness))
                .foregroundColor(Color(UIColor.white))
                .rotationEffect(.degrees(isRotating ? 0 : 360))
                .onAppear {
                    withAnimation(Animation.linear(duration: 0.7)
                        .repeatForever(autoreverses: false)) {
                        self.isRotating.toggle()
                    }

                    withAnimation(Animation.linear(duration: 0.8)
                        .repeatForever(autoreverses: true)) {
                        self.animateStrokeStart.toggle()
                    }

                    withAnimation(Animation.linear(duration: 0.8)
                        .repeatForever(autoreverses: true)) {
                        self.animateStrokeEnd.toggle()
                    }
                }
        }
    }
}

struct SaveSpinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner()
            .frame(width: 200, height: 200, alignment: .center)
    }
}

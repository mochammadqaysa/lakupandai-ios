//
//  ImageSlider.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 05/10/23.
//

import SwiftUI

struct ImageSlider: View {
    
    // 1
    private let images = ["ads", "slide_1", "slide_2"]
    @State private var selection = 0
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        // 2
        TabView(selection: $selection) {
            ForEach(images, id: \.self) { item in
                Image(item)
                    .resizable()
                    .scaledToFill()
                    .tag(images.firstIndex(of: item)!)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onReceive(timer) { _ in
            withAnimation {
                let newIndex = (selection + 1) % images.count
                selection = newIndex
            }
        }
    }
}

struct ImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        // 4
        ImageSlider()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}

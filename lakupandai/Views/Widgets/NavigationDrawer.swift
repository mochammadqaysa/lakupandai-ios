//
//  NavigationDrawer.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import SwiftUI

struct NavigationDrawer: View {
    private let width = UIScreen.main.bounds.width - 120
    let isOpen: Bool
    @Binding var isLogin: Bool
    
    var body: some View {
        HStack {
            Drawer(isLogin: self.$isLogin)
                .frame(width: self.width)
                .offset(x: self.isOpen ? 0 : -self.width)
                .animation(.easeInOut(duration: 0.3), value: isOpen)
            //                .animation(.default)
            Spacer()
        }
    }
}

struct NavigationDrawer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationDrawer(isOpen: false, isLogin: .constant(true))
    }
}

struct DrawerContent: View {
    var body: some View {
        Color.blue
    }
}

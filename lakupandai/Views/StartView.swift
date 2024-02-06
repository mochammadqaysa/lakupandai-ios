//
//  StartView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/12/23.
//

import SwiftUI

struct StartView: View {
    
    @ObservedObject var startVM = StartViewModel()
    var body: some View {
        NavigationStack {
            if startVM.isUnlocked {
                HomeView(isLogin: $startVM.isUnlocked)
            } else {
                LoginView(isUnlocked: $startVM.isUnlocked)
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

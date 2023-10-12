//
//  HomeViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import Foundation
import SwiftUI

class HomeViewModel : ObservableObject {
    @Published var isDrawerOpen: Bool = false
    @Published var showDrawer: Bool = false
    
    var columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
}

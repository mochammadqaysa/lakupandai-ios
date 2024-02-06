//
//  HasilTarikTunaiViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 16/01/24.
//

import Foundation
import SwiftUI

class HasilTarikTunaiViewModel : ObservableObject {
    
    
    @Published var showAlert: Bool = false
    @Published var showToastResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
}

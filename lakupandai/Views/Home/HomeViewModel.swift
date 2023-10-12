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
    
    
    @Published var showAktivasiRekeningBaru = false
    @Published var showInformasiRekening = false
    @Published var showSetorTunai = false
    @Published var showTarikTunai = false
    @Published var showTransfer = false
    @Published var showPembelian = false
    @Published var showPembayaran = false
    
    
    @Published var showNotification: Bool = false
    
    var columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
}

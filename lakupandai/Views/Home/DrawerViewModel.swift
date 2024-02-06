//
//  MenuDrawerViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 05/10/23.
//

import Foundation

class MenuContent: Identifiable, ObservableObject {
    var id = UUID()
    var name: String = ""
    var image: String = ""
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

class DrawerViewModel: ObservableObject {
    @Published var items = [
        MenuContent(name: "Aktivasi Rekening Baru", image: "ic_aktivasi_rekening_baru_white"),
        MenuContent(name: "Informasi Rekening", image: "ic_informasi_rekening_white"),
        MenuContent(name: "Setor Tunai", image: "ic_setor_tunai_white"),
        MenuContent(name: "Tarik Tunai", image: "ic_tarik_tunai_white"),
        MenuContent(name: "Transfer", image: "ic_transfer_white"),
        MenuContent(name: "Pembelian", image: "ic_pembelian_white"),
        MenuContent(name: "Pembayaran", image: "ic_pembayaran_white"),
        MenuContent(name: "Log Transaksi", image: "ic_log_transaksi_white"),
        MenuContent(name: "Kotak Masuk", image: "ic_email"),
        MenuContent(name: "Printer Setting", image: "ic_bluetooth")
    ]
    
    @Published var isLogin = true
    @Published var showAktivasiRekeningBaru = false
    @Published var showInformasiRekening = false
    @Published var showSetorTunai = false
    @Published var showTarikTunai = false
    @Published var showTransfer = false
    @Published var showPembelian = false
    @Published var showPembayaran = false
}

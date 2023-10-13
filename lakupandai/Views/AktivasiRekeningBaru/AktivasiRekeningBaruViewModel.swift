//
//  AktivasiRekeningBaruViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import Foundation

class AktivasiRekeningBaruViewModel : ObservableObject {
    @Published var nik = ""
    @Published var namaDebitur = ""
    @Published var jenisKelamin = ""
    @Published var tempatLahir = ""
    @Published var tanggalLahir = ""
    @Published var kodePekerjaan = ""
    @Published var kotaKab = ""
    @Published var kecamatan = ""
    @Published var kelurahanDes = ""
    @Published var statusPerkawinan = ""
    @Published var namaIbu = ""
    @Published var kodePendidikan = ""
    @Published var nomorTelp = ""
}

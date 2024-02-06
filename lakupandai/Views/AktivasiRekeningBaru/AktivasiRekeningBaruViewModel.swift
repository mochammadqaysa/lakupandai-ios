//
//  AktivasiRekeningBaruViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import Foundation
import SwiftUI

class AktivasiRekeningBaruViewModel : ObservableObject {
    @Published var nik : String = ""
    @Published var namaDebitur = ""
    @Published var selectedJenisKelamin : [String : String] = [:]
    @Published var tempatLahir = ""
    @Published var tanggalLahir = Date.now
    @Published var selectedKodePekerjaan : [String : String] = [:]
    @Published var selectedProvinsi : [String : String] = [:]
    @Published var selectedKabupaten : [String : String] = [:]
    @Published var selectedKecamatan : [String : String] = [:]
    @Published var selectedKelurahan : [String : String] = [:]
    @Published var selectedStatusPerkawinan : [String : String] = [:]
    @Published var selectedPendidikan : [String : String] = [:]
    @Published var namaIbu = ""
    @Published var kodePendidikan = ""
    @Published var nomorTelp = ""
    
    @Published var searchPekerjaan = ""
    @Published var searchProvinsi = ""
    @Published var searchKabupaten = ""
    @Published var searchKecamatan = ""
    @Published var searchKelurahan = ""
    
    
    @Published var listJenisKelamin: [[String : String]] = []
    @Published var listPendidikan: [[String : String]] = []
    @Published var listKawin: [[String : String]] = []
    @Published var listKerja: [[String : String]] = []
    @Published var listProvinsi: [[String : String]] = []
    @Published var listKabupaten: [[String : String]] = []
    @Published var listKecamatan: [[String : String]] = []
    @Published var listKelurahan: [[String : String]] = []
    @Published var listStatusPerkawinan: [[String : String]] = []
    
    
    @Published var fullListKabupaten: [[String : String]] = []
    @Published var fullListKecamatan: [[String : String]] = []
    @Published var fullListKelurahan: [[String : String]] = []
    
    
    @Published var dataForm : [ItemValue] = []
    
    var filteredListKerja: [[String : String]] {
        self.listKerja.filter { data in
            self.searchPekerjaan.isEmpty ? true : data["keterangan"]!.lowercased().contains(self.searchPekerjaan.lowercased())
        }
    }
    
    var filteredListProvinsi: [[String : String]] {
        self.listProvinsi.filter { data in
            self.searchProvinsi.isEmpty ? true : data["keterangan"]!.lowercased().contains(self.searchProvinsi.lowercased())
        }
    }
    
    var filteredListKabupaten: [[String : String]] {
        self.listKabupaten.filter { data in
            self.searchKabupaten.isEmpty ? true : data["keterangan"]!.lowercased().contains(self.searchKabupaten.lowercased())
        }
    }
    
    var filteredListKecamatan: [[String : String]] {
        self.listKecamatan.filter { data in
            self.searchKecamatan.isEmpty ? true : data["keterangan"]!.lowercased().contains(self.searchKecamatan.lowercased())
        }
    }
    
    var filteredListKelurahan: [[String : String]] {
        self.listKelurahan.filter { data in
            self.searchKelurahan.isEmpty ? true : data["keterangan"]!.lowercased().contains(self.searchKelurahan.lowercased())
        }
    }
    
    
    @Published var showAlert: Bool = false
    @Published var showToastResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    init() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.initData()
            print("ini selected prov : \(self.selectedProvinsi)")
            self.isLoading = false
        }
    }
    
    func onChangeProvinsi(newProvinsi : [String : String]) {
        if !self.fullListKabupaten.isEmpty {
            self.listKabupaten = self.fullListKabupaten.filter { data in
                data["kode_ref"] == newProvinsi["kode"]
            }
        }
    }
    
    func onChangeKabupaten() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
            let params: [String: Any] = [
                ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
                ConstantTransaction.ACTION : "get_kel_data",
                "prov" : self.selectedProvinsi["kode"],
                "kab" : self.selectedKabupaten["kode"],
            ]
            do {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
                let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
                let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
                let res = self.apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
                let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
                let responseData = decEn!.data(using: .utf8)
                do {
                    
                    let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                    let rc = resjson!["RC"] as? String
                    let rm = resjson!["RM"] as? String
                    print("RC value: \(rc)")
                    if rc == "00" {
                        if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                            if let dataKecamatan = rmData["dataKecamatan"] as? [[String : String]] {
                                self.fullListKecamatan = dataKecamatan
                                self.listKecamatan = dataKecamatan
                            }
                            if let dataKelurahan = rmData["dataKelurahan"] as? [[String : String]] {
                                self.fullListKelurahan = dataKelurahan
                                self.listKelurahan = self.fullListKelurahan.filter { data in
                                    data["kode_ref"] == self.selectedKecamatan["kode"]
                                }
                                
                                print("data kelurahan : \(self.listKelurahan)")
                            }
                        }
                    } else {
                        self.showAlert = true
                        self.alertMessage = rm!
                    }
                } catch {
                    self.showAlert = true
                    self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                    print("Error parsing JSON: \(error)")
                }
                
            } catch {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                print("Error : \(error)")
            }
            self.isLoading = false
        }
    }
    
    func onChangeKecamatan(newKecamatan : [String : String]) {
        if !self.fullListKelurahan.isEmpty {
            self.listKelurahan = self.fullListKelurahan.filter { data in
                data["kode_ref"] == newKecamatan["kode"]
            }
        }
    }
    
    func initData() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
            ConstantTransaction.ACTION : "get_regist_data"
        ]
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            if let decryptData = decEn {
                let responseData = decryptData.data(using: .utf8)
                do {
                    // Parsing JSON
                    let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                    let rc = resjson!["RC"] as? String
                    let rm = resjson!["RM"] as? String
                    print("RC value: \(rc)")
                    if rc == "00" {
                        if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                            print("asd ini rm data : \(rmData)")
                            if let dataJenisKelamin = rmData["dataJenisKelamin"] as? [[String : String]] {
                                self.listJenisKelamin = dataJenisKelamin
                                self.selectedJenisKelamin = listJenisKelamin.first!
                            }
                            if let dataPendidikan = rmData["dataPendidikan"] as? [[String : String]] {
                                self.listPendidikan = dataPendidikan
                                
                            }
                            if let dataKawin = rmData["dataKawin"] as? [[String : String]] {
                                self.listKawin = dataKawin
                            }
                            if let dataKerja = rmData["dataKerja"] as? [[String : String]] {
                                self.listKerja = dataKerja
                                self.selectedKodePekerjaan = dataKerja.first!
                            }
                            if let dataProvinsi = rmData["dataProvinsi"] as? [[String : String]] {
                                self.listProvinsi = dataProvinsi
    //                            self.selectedProvinsi = listProvinsi.first!
                            }
                            if let dataKabupaten = rmData["dataKabupaten"] as? [[String : String]] {
                                self.fullListKabupaten = dataKabupaten
                                self.listKabupaten = self.fullListKabupaten.filter { data in
                                    data["kode_ref"] == self.selectedProvinsi["kode"]
                                }
    //                                self.selectedKabupaten = listKabupaten.first!
                            }
                            if let dataKawin = rmData["dataKawin"] as? [[String : String]] {
                                self.listKawin = dataKawin
                                self.selectedStatusPerkawinan = dataKawin.first!
                            }
                        }
                    }else{
                        showAlert = true
                        alertMessage = rm!
                    }
                } catch {
                    showAlert = true
                    alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                    print("Error parsing JSON: \(error)")
                }
            } else {
                showAlert = true
                alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            }
            
            
        } catch {
            showAlert = true
            alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            print("Error : \(error)")
        }
    }
    
    func validateForm() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (self.isFormReady()) {
                self.aktivasiRekeningBaru()
            } else {
                self.showAlert = true
                self.alertMessage = "Mohon lengkapi form anda!"
            }
            self.isLoading = false
        }
        
    }
    
    func isFormReady() -> Bool {
        if (self.nik.count < 1) {
            print("asd error 1")
            return false
        }
        if (self.namaDebitur.count < 1) {
            print("asd error 2")
            return false
        }
        if (self.tempatLahir.count < 1) {
            print("asd error 3")
            return false
        }
        if (self.selectedJenisKelamin.isEmpty) {
            print("asd error 4")
            return false
        }
        if (self.selectedKodePekerjaan.isEmpty) {
            print("asd error 5")
            return false
        }
        if (self.selectedProvinsi.isEmpty) {
            print("asd error 6")
            return false
        }
        if (self.selectedKabupaten.isEmpty) {
            print("asd error 7")
            return false
        }
        if (self.selectedKecamatan.isEmpty) {
            print("asd error 8")
            return false
        }
        if (self.selectedKelurahan.isEmpty) {
            print("asd error 9")
            return false
        }
        if (self.tanggalLahir.description.isEmpty) {
            print("asd error 10")
            return false
        }
        if (self.namaIbu.isEmpty) {
            print("asd error 11")
            return false
        }
        if (self.nomorTelp.isEmpty) {
            print("asd error 12")
            return false
        }
        if (self.selectedPendidikan.isEmpty) {
            print("asd error 13")
            return false
        }
        return true
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    func aktivasiRekeningBaru() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            "msisdn_agen" : msisdn,
            "nik" : self.nik,
            "nama" : self.namaDebitur,
            "tempat_lahir" : self.tempatLahir,
            "tanggal_lahir" : formattedDate(date: self.tanggalLahir),
            "provinsi" : self.selectedProvinsi["keterangan"],
            "kotakabupaten" : self.selectedKabupaten["keterangan"],
            "kecamatan" : self.selectedKecamatan["keterangan"],
            "kelurahandesa" : self.selectedKelurahan["keterangan"],
            "jenis_kelamin" : self.selectedJenisKelamin["kode"],
            "kode_pekerjaan" : self.selectedKodePekerjaan["kode"],
            "status_kawin" : self.selectedStatusPerkawinan["kode"],
            "ibukandung" : self.namaIbu,
            "nohp" : self.nomorTelp,
            "kode_pendidikan" : self.selectedPendidikan["kode"],
            ConstantTransaction.ACTION : "pendaftaran_rekening_langsung"
        ]
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            if let decryptData = decEn {
                if decryptData.contains(ConstantTransaction.CONNECTION_LOST) {
                    showAlert = true
                    alertMessage = ConstantTransaction.CONNECTION_LOST
                } else if decryptData.contains(ConstantTransaction.SERVER_ERROR) {
                    showAlert = true
                    alertMessage = ConstantTransaction.SERVER_ERROR
                } else if decryptData.contains(ConstantTransaction.CONNECTION_ERROR) {
                    showAlert = true
                    alertMessage = ConstantTransaction.CONNECTION_ERROR
                } else {
                    let responseData = decryptData.data(using: .utf8)
                    print("asd response \(decryptData)")
                    do {
                        // Parsing JSON
                        let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                        let rc = resjson!["RC"] as? String
                        let rm = resjson!["RM"] as? String
                        if rc == "00" {
                            UserDefaultsManager.shared.saveString(resultEnc!, forKey: "temp_body_aktivasi")
                            self.dataForm.removeAll()
                            self.dataForm.append(ItemValue(header: "NIK", value: self.nik))
                            self.dataForm.append(ItemValue(header: "Nama", value: self.namaDebitur))
                            self.dataForm.append(ItemValue(header: "Jenis kelamin", value: self.selectedJenisKelamin["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "Tempat lahir", value: self.tempatLahir))
                            self.dataForm.append(ItemValue(header: "Tanggal lahir", value: formattedDate(date: self.tanggalLahir)))
                            self.dataForm.append(ItemValue(header: "Pekerjaan", value: self.selectedKodePekerjaan["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "Provinsi", value: self.selectedProvinsi["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "Kabupaten/Kota", value: self.selectedKabupaten["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "Kecamatan", value: self.selectedKecamatan["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "Desa/Kelurahan", value: self.selectedKelurahan["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "Status perkawinan", value: self.selectedStatusPerkawinan["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "Nama ibu kandung", value: self.namaIbu))
                            self.dataForm.append(ItemValue(header: "Pendidikan", value: self.selectedPendidikan["keterangan"]!))
                            self.dataForm.append(ItemValue(header: "No HP Nasabah", value: self.nomorTelp))
                            self.nextStep = true
                        } else {
                            showAlert = true
                            alertMessage = rm!
                        }
                        
                    } catch {
                        showAlert = true
                        alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                        print("Error parsing JSON: \(error)")
                    }
                }
            } else {
                showAlert = true
                alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            }
        } catch {
            showAlert = true
            alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            print("Error : \(error)")
        }
    }
}

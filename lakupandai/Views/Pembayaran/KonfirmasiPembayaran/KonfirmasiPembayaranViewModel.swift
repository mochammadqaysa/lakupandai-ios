//
//  KonfirmasiPembayaranViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/12/23.
//

import Foundation
import SwiftUI
import UserNotifications

class KonfirmasiPembayaranViewModel : ObservableObject {
    @Published var otpNasabah: String = ""
    @Published var pinAgen: String = ""
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var metodePembayaran: String = ""
    @Published var dataPembayaran : [ItemValue] = []
    @Published var dataForm : [String : Any] = [:]
    @Published var dataToken : String = ""
    
    
    @Published var dataKonfirmasi : [ItemValue] = []
    @Published var dataLayanan : String = ""
    
    @ObservedObject var apiService = ApiService()
    
    func validateForm(metodePembayaran : String, dataPembayaran : [ItemValue], dataForm : [String : Any], dataToken : String) {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.otpNasabah.isEmpty && metodePembayaran == "Debit" {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
                self.isLoading = false
            } else if self.otpNasabah.count < 6 && metodePembayaran == "Debit" {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_TOKEN_LESS_THAN_6
                self.isLoading = false
            } else if self.pinAgen.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_PIN_LESS_THAN_6
                self.isLoading = false
            } else {
                self.metodePembayaran = metodePembayaran
                self.dataPembayaran = dataPembayaran
                self.dataForm = dataForm
                self.dataToken = dataToken
                self.doKonfirmasiPembayaran()
                self.isLoading = false
            }
        }
    }
    
    func doKonfirmasiPembayaran() {
        var json : [String : Any] = [:]
        do {
            let noHpAgen = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
            if self.metodePembayaran == "Debit" {
                json.updateValue(noHpAgen, forKey: ConstantTransaction.MSISDN_AGEN_LOGIN)
                json.updateValue(self.pinAgen, forKey: ConstantTransaction.PIN_PEMBAYARAN)
                json.updateValue(self.otpNasabah, forKey: ConstantTransaction.OTP_PEMBAYARAN)
                json.updateValue(self.dataForm[ConstantTransaction.KODE_PRODUK], forKey: ConstantTransaction.KODE_PRODUK)
                json.updateValue(self.metodePembayaran, forKey: ConstantTransaction.TIPE)
                json.updateValue(ConstantTransaction.ACTION_KONFIRMASI_PEMBAYARAN, forKey: ConstantTransaction.ACTION)
            } else {
                json.updateValue(noHpAgen, forKey: ConstantTransaction.MSISDN_AGEN_LOGIN)
                json.updateValue(self.pinAgen, forKey: ConstantTransaction.PIN_PEMBAYARAN)
                json.updateValue(self.dataForm[ConstantTransaction.KODE_PRODUK], forKey: ConstantTransaction.KODE_PRODUK)
                json.updateValue(self.dataToken, forKey: ConstantTransaction.OTP_PEMBAYARAN)
                json.updateValue(self.metodePembayaran, forKey: ConstantTransaction.TIPE)
                json.updateValue(ConstantTransaction.ACTION_KONFIRMASI_PEMBAYARAN, forKey: ConstantTransaction.ACTION)
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: json,options: .sortedKeys) else { return }
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            
            let cleanedResponseString = decEn!.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
            let responseData = cleanedResponseString.data(using: .utf8)
            print("Response : \(cleanedResponseString)")
            do {
                let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                let rc = resjson!["RC"] as? String
                let rmString = resjson!["RM"] as? String
                print("RC value: \(rc!)")
                if rc == "00" {
                    let rmData = rmString!.data(using: .utf8)
                    let rmJson = try JSONSerialization.jsonObject(with: rmData!, options: []) as? [String: Any]
                    if let rmData = rmJson!["data"] as? [[String: String]] {
                        print("asd ini data konfirm : \(rmData)")
                        if self.metodePembayaran == "Tunai" {
                            var resi : String = ""
                            var nominal : String = ""
                            var layanan : String = ""
                            var tanggal : String = ""
                            for rmDatum in rmData {
                                if rmDatum["header"]!.contains("Resi") {
                                    resi = rmDatum["value"] ?? ""
                                } else if rmDatum["header"]!.contains("Jumlah Bayar") {
                                    nominal = rmDatum["value"] ?? ""
                                } else if rmDatum["header"]!.contains("Layanan") {
                                    layanan = rmDatum["value"] ?? ""
                                    self.dataLayanan = layanan
                                } else if rmDatum["header"]!.contains("Waktu") {
                                    tanggal = rmDatum["value"] ?? ""
                                }
                            }
                            
                            
                            if let rmData = rmJson!["data"] as? [[String: String]] {
                                dataKonfirmasi.removeAll()
                                for rmDatum in rmData {
                                    dataKonfirmasi.append(ItemValue(jsonDictionary: rmDatum)!)
                                }
                                self.nextStep = true
                                NotificationManager.pushNotification(title: "Pembayaran \(layanan)", body: "Tekan untuk melihat transaksi di kotak masuk")
                            }
                        }
                        
                        
                    }
                } else if rc == "70" || rc == "21" {
                    showAlert = true
                    alertMessage = rmString!
                } else {
                    showAlert = true
                    alertMessage = rmString!
                }
            } catch {
                showAlert = true
                alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                print("Error parsing JSON: \(error)")
            }
        } catch {
            showAlert = true
            alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            print("Error parsing JSON: \(error)")
            
        }
        
    }
}

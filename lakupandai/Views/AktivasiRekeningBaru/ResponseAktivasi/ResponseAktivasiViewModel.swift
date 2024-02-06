//
//  ResponseAktivasiViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/02/24.
//

import Foundation
import SwiftUI

class ResponseAktivasiViewModel : ObservableObject {
    @Published var otpNasabah = ""
    @Published var pinAgen = ""
    
    @Published var dataLayanan = ""
    @Published var dataResponse : [ItemValue] = []
    @Published var dataTransferDari : [ItemValue] = []
    @Published var dataTransferKe : [ItemValue] = []
    
    @Published var detikRequestOtp = 30
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var showAlert: Bool = false
    @Published var showToastResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    
    @ObservedObject var apiService = ApiService()
    
    func requestOtp() {
        let requestAktivasi = UserDefaultsManager.shared.getString(forKey: "temp_body_aktivasi")
        if let req = requestAktivasi {
            if req.isEmpty {
                self.showAlert = true
                self.alertMessage = Constant.BELUM_TRANSAKSI
            } else {
                print("ada bozz : \(requestAktivasi)")
                do {
                    let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
                    let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: req, timeout: timeout)
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
                                    self.detikRequestOtp = 30
                                    self.showAlert = true
                                    self.alertMessage = "OTP berhasil dikirim, silakan masukan OTP"
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
                    self.showAlert = true
                    self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                    print("Error : \(error)")
                }
//                if let params =
            }
        } else {
            self.showAlert = true
            self.alertMessage = Constant.BELUM_TRANSAKSI
        }
    }
    
    func validateForm() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.otpNasabah.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_CONF_CODE_EMPTY
            } else if self.otpNasabah.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_CONF_CODE_LESS_THAN_6
            } else if self.pinAgen.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_CONF_CODE_EMPTY
            } else if self.pinAgen.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_CONF_CODE_LESS_THAN_6
            } else {
                self.konfirmasiAktivasi()
            }
            self.isLoading = false
        }
    }
    
    func konfirmasiAktivasi() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_REK_BARU : msisdn,
            ConstantTransaction.TOKEN_REK_BARU : self.otpNasabah,
            ConstantTransaction.PIN_REK_BARU : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_REK_BARU
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
                            self.showToastResponse = true
                            self.alertMessage = rm!
                            
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

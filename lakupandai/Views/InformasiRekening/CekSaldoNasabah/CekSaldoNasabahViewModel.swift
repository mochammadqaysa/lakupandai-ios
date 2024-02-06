//
//  CekSaldoNasabahViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import Foundation
import SwiftUI

class CekSaldoNasabahViewModel : ObservableObject {
    @Published var pinAgen = ""
    @Published var noTelpon = ""
    
    @Published var rmResponse = ""
    
    
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    func validateForm() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.pinAgen.isEmpty || self.noTelpon.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.pinAgen.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_PIN_LESS_THAN_6
            } else if self.noTelpon.count < 10 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_NUMBER_LESS_THAN_10
            } else {
                self.cekSaldoNasabah()
            }
            
            self.isLoading = false
        }
    }
    
    func cekSaldoNasabah() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_CEK_SALDO_NASABAH : msisdn,
            ConstantTransaction.MSISDN_NASABAH_CEK_SALDO_NASABAH : self.noTelpon,
            ConstantTransaction.PIN_CEK_SALDO_NASABAH : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_CEK_SALDO_NASABAH
        ]
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            if let decryptData = decEn {
                let responseData = decryptData.data(using: .utf8)
                print("asd response \(decryptData)")
                do {
                    // Parsing JSON
                    let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                    let rc = resjson!["RC"] as? String
                    let rm = resjson!["RM"] as? String
                    if rc == "00" {
                        if let responseMessage = rm {
                            self.rmResponse = responseMessage
                            self.nextStep = true
                        } else {
                            showAlert = true
                            alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                        }
                    } else {
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
}

//
//  KonfirmasiSetorLakupandaiViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 05/01/24.
//

import Foundation
import SwiftUI


class KonfirmasiSetorLakupandaiViewModel : ObservableObject {
    @Published var pinAgen: String = ""
    @Published var token: String = ""
    
    @Published var showToastResponse: Bool = false
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    func validateForm(dataToken : String) {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.pinAgen.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.pinAgen.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_PIN_LESS_THAN_6
            } else {
                self.token = dataToken
                self.konfirmasiSetor()
            }
            self.isLoading = false
        }
    }
    
    func konfirmasiSetor() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_KONF_SETOR_TUNAI : msisdn,
            ConstantTransaction.TOKEN_KONF_SETOR_TUNAI : self.token,
            ConstantTransaction.PIN_KONF_SETOR_TUNAI : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_KONFIRMASI_SETOR_TUNAI
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
                        self.showToastResponse = true
                        self.alertMessage = rm!
                        print("asd response \(resjson)")
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

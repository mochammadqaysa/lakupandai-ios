//
//  KonfirmasiRequestTransferLakupandaiViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 23/01/24.
//

import Foundation
import SwiftUI

class KonfirmasiRequestTransferLakupandaiViewModel : ObservableObject {
    @Published var pinAgen = ""
    
    @Published var dataLayanan = ""
    @Published var dataResponse : [ItemValue] = []
    @Published var dataTransferDari : [ItemValue] = []
    @Published var dataTransferKe : [ItemValue] = []
    
    @Published var showAlert: Bool = false
    @Published var showToastResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    
    @ObservedObject var apiService = ApiService()
    
    func validateForm(token : String) {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.pinAgen.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.pinAgen.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_PIN_LESS_THAN_6
            } else {
                self.konfirmasiRequestTransferLakupandai(token: token)
            }

            self.isLoading = false
        }
    }
    
    func konfirmasiRequestTransferLakupandai(token : String) {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_REQUEST_TRANSFER_KONFIRMASI : msisdn,
            ConstantTransaction.TOKEN_REQUEST_TRANSFER_KONFIRMASI : token,
            ConstantTransaction.PIN_REQUEST_TRANSFER_KONFIRMASI : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_REQUEST_TRANSFER_KONFIRMASI_LAKUPANDAI
        ]
        
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            if let decryptData = decEn {
                if decryptData.contains(ConstantTransaction.CONNECTION_LOST) {
                    self.showAlert = true
                    self.alertMessage = ConstantTransaction.CONNECTION_LOST
                } else if decryptData.contains(ConstantTransaction.SERVER_ERROR) {
                    self.showAlert = true
                    self.alertMessage = ConstantTransaction.SERVER_ERROR
                } else if decryptData.contains(ConstantTransaction.CONNECTION_ERROR) {
                    self.showAlert = true
                    self.alertMessage = ConstantTransaction.CONNECTION_ERROR
                } else {
                    let responseData = decryptData.data(using: .utf8)
                    print("asd response \(decryptData)")
                    do {
                        // Parsing JSON
                        let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                        let rc = resjson!["RC"] as? String
                        let rm = resjson!["RM"] as? String
                        if rc == "00" {
                            
                            if let rmToken = resjson!["token"] as? String {
                                print("ini tokennya gezz : \(rmToken)")
    //                            self.token = rmToken
//                                self.dataToken = rmToken
                            }
                            if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                if let data = rmData["data"] as? [[String: String]] {
                                    print("asd ini datanya gaes 1 : \(data)")
                                    UserDefaultsManager.shared.saveString(resultEnc!, forKey: "temp_body_transfer_lakupandai")
                                    for rmDatum in data {
                                        if let item = ItemValue(jsonDictionary: rmDatum) {
                                            if item.header == "Keterangan" {
                                                self.showToastResponse = true
                                                self.alertMessage = item.value
                                            }
                                        }
                                    }
                                }
                            } else {
                                self.showAlert = true
                                self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
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
                }
            } else {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            }
        } catch {
            self.showAlert = true
            self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            print("Error : \(error)")
        }
    }
}


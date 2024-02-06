//
//  SetorBPDViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import Foundation
import SwiftUI

class SetorBPDViewModel : ObservableObject {
    @Published var nominal = ""
    @Published var noRek = ""
    
    @Published var dataResponse: [ItemValue] = []
    @Published var dataSetor: [ItemValue] = []
    @Published var token = ""
    
    
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    func validateForm() {
        
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.nominal.isEmpty || self.noRek.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.noRek.count < 10 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_NUMBER_LESS_THAN_10
            } else if self.nominal.count < 1 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_NOMINAL_LESS_THAN_1
            } else {
                self.setorTunaiBPD()
            }
            self.isLoading = false
        }
    }
    
    func setorTunaiBPD() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_SETOR_TUNAI : msisdn,
            ConstantTransaction.REK_NASABAH : self.noRek,
            ConstantTransaction.NOMINAL_SETOR_TUNAI : self.nominal,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_SETOR_TUNAI_REGULER
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
                        if let rmToken = resjson!["token"] as? String {
                            print("ini tokennya gezz : \(rmToken)")
                            self.token = rmToken
                        }
                        if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                            if let data = rmData["data"] as? [[String: String]] {
                                print("asd ini datanya gaes 1 : \(data)")
                                dataResponse.removeAll()
                                dataSetor.removeAll()
                                for rmDatum in data {
                                    dataResponse.append(ItemValue(jsonDictionary: rmDatum)!)
                                    dataSetor.append(ItemValue(jsonDictionary: rmDatum)!)
                                }
                                
                                self.nextStep = true
                            }
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

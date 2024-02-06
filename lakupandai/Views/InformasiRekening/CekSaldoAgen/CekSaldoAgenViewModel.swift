//
//  CekSaldoAgenViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import Foundation
import SwiftUI

class CekSaldoAgenViewModel : ObservableObject {
    @Published var pinAgen: String = ""
    @Published var nextStep: Bool = false
    @Published var dataResponse: [ItemValue] = []
    @Published var dataSaldo: [ItemValue] = []
    
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    func validatePin() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.pinAgen.isEmpty {
                self.pinAgen = ""
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.pinAgen.count < 6 {
                self.pinAgen = ""
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_PIN_LESS_THAN_6
            } else {
                self.cekSaldoAgen()
            }
            
            self.isLoading = false
        }
    }
    
    func cekSaldoAgen() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
            ConstantTransaction.PIN_CEK_SALDO_AGEN : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_CEK_SALDO_AGEN
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
                    if rc == "00" {
                        if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                            print("asd data rm : \(rmData)")
                            if let rmData = rmData["data"] as? [[String: String]] {
                                print("asd ini datanya gaes 1 : \(rmData)")
                                dataResponse.removeAll()
                                for rmDatum in rmData {
                                    let dataSaldo = ItemValue(jsonDictionary: rmDatum)!
                                    dataResponse.append(dataSaldo)
                                }
                                let dataNama = dataResponse.first(where: { find in
                                    return find.header == "User Name"
                                })
                                let dataUsername = dataResponse.first(where: { find in
                                    return find.header == "User Id"
                                })
                                let dataRekening = dataResponse.first(where: { find in
                                    return find.header == "User Account"
                                })
                                let dataTanggal = dataResponse.first(where: { find in
                                    return find.header == "Tanggal"
                                })
                                let dataBalance = dataResponse.first(where: { find in
                                    return find.header == "Balance"
                                })
                                
                                if let nama = dataNama, let username = dataUsername, let rekening = dataRekening, let tanggal = dataTanggal, let balance = dataBalance {
                                    self.dataSaldo.append(ItemValue(header: "Nama", value: nama.value))
                                    self.dataSaldo.append(ItemValue(header: "Username", value: username.value))
                                    self.dataSaldo.append(ItemValue(header: "Tanggal", value: tanggal.value))
                                    self.dataSaldo.append(ItemValue(header: "No. Rekening", value: rekening.value))
                                    self.dataSaldo.append(ItemValue(header: "Jumlah", value: "Rp. " + balance.value))
                                }
                                
                                
                                self.nextStep = true
                            }
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

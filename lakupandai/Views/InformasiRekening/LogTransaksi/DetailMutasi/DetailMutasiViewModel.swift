//
//  DetailMutasiViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/01/24.
//

import Foundation
import SwiftUI

class DetailMutasiViewModel : ObservableObject {
    
    @Published var listItem: [ItemValue] = []
    
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var isLoadData: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
//    init() {
//        self.isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.initData()
//            self.isLoading = false
//        }
//    }
    
    func initData(idNotif : Int) {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
            ConstantTransaction.ID_NOTIF : idNotif,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_GET_DETAIL_TRX
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
                            if let dataNotif = rmData["data"] as? [[String: String]] {
                                for data in dataNotif {
                                    let mutasi = ItemValue(jsonDictionary: data)!
                                    self.listItem.append(mutasi)
                                }
                                print("asd detail notif : \(listItem)")
                            }
                        }
                    } else {
                        self.showAlert = true
                        self.alertMessage = rm!
                    }
                } catch {
                    self.showAlert = true
                    self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
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

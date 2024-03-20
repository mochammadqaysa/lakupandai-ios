//
//  NotificationViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import Foundation
import SwiftUI

class NotificationViewModel : ObservableObject {
    let currentDate = Date()
    
    @Published var startDate : Date = .now
    @Published var endDate : Date = .now
    @Published var showRangeDate : Bool = false
    @Published var dateRange: ClosedRange<Date>? = nil
    @Published var initDateRange: ClosedRange<Date>? = nil
    
    
    @Published var dataNotif: [Notifikasi] = []
    @Published var sizePerPage: Int = 0
    @Published var totalPages: Int = 0
    @Published var totalMutasi: Int = 0
    @Published var page: Int = 0
    @Published var rc: Int = 0
    
    
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
            self.isLoading = false
        }
    }
    
    func initData() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
            ConstantTransaction.PAGE_JSON : "0",
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_GET_LIST_NOTIF
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
                    do {
                        // Parsing JSON
                        let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                        let rc = resjson!["RC"] as? String
                        let rm = resjson!["RM"] as? String
                        print("ini res json \(resjson)")
                        if rc == "00" {
                            if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                if let dataNotifikasi = rmData["data"] as? [[String: Any]] {
                                    DispatchQueue.main.async {
                                        self.dataNotif.removeAll()
                                    }
                                    for data in dataNotifikasi {
                                        if let notif = Notifikasi(jsonDictionary: data) {
                                            DispatchQueue.main.async {
                                                self.dataNotif.append(notif)
                                            }
                                        }
                                    }
                                } 
                                
                                
                                
                            } else {
                                DispatchQueue.main.async {
//                                    self.dataMutasi.removeAll()
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

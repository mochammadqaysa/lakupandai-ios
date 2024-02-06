//
//  LogTransaksiViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import Foundation
import SwiftUI

class LogTransaksiViewModel : ObservableObject {
    let currentDate = Date()

    @Published var startDate : Date = .now
    @Published var endDate : Date = .now
    @Published var showRangeDate : Bool = false
    @Published var dateRange: ClosedRange<Date>? = nil
    @Published var initDateRange: ClosedRange<Date>? = nil
    
    
    @Published var dataMutasi: [MutasiRekening] = []
    @Published var sizePerPage: Int = 0
    @Published var totalPages: Int = 0
    @Published var totalMutasi: Int = 0
    @Published var page: Int = 0
    @Published var rc: Int = 0
    
    
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var isLoadData: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    init() {
        dataMutasi.removeAll()
        self.isLoading = true
        self.isLoadData = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let startOfDay = Calendar.current.startOfDay(for: self.currentDate)
            let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self.currentDate) ?? self.currentDate
            self.initDateRange = startOfDay...endOfDay
            self.initData()
            self.isLoading = false
            self.isLoadData = false
        }
    }
    
    func initData() {
        if let range = self.initDateRange {
            let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
            let params: [String: Any] = [
                ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
                ConstantTransaction.START_DATE : formattedDate(range.lowerBound),
                ConstantTransaction.END_DATE : formattedDate(range.upperBound),
                ConstantTransaction.PAGE_JSON : self.page.numberString,
                ConstantTransaction.ACTION : ConstantTransaction.ACTION_MUTASI
            ]
            self.dateRange = self.initDateRange
            
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
                                    if let dataMutasi = rmData["mutasi"] as? [[String: Any]] {
                                        DispatchQueue.main.async {
                                            self.dataMutasi.removeAll()
                                        }
                                        for data in dataMutasi {
                                            let mutasi = MutasiRekening(jsonDictionary: data)!
                                            DispatchQueue.main.async {
                                                self.dataMutasi.append(mutasi)
                                            }
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.dataMutasi.removeAll()
                                        }
                                    }
                                    
                                    if let dataSizePerPage = rmData["sizePerPage"] as? Int {
                                        DispatchQueue.main.async {
                                            self.sizePerPage = dataSizePerPage
                                        }
                                    }
                                    
                                    if let dataTotalPages = rmData["totalPages"] as? Int {
                                        DispatchQueue.main.async {
                                            self.totalPages = dataTotalPages
                                        }
                                    }
                                    
                                    if let dataTotalMutasi = rmData["totalMutasi"] as? Int {
                                        DispatchQueue.main.async {
                                            self.totalMutasi = dataTotalMutasi
                                        }
                                    }
                                    
                                    if let dataPage = rmData["page"] as? Int {
                                        DispatchQueue.main.async {
                                            self.page = dataPage + 1
                                        }
                                    }
                                    
                                    if let dataRc = rmData["rc"] as? Int {
                                        DispatchQueue.main.async {
                                            self.rc = dataRc
                                        }
                                    }
                                    
                                    
                                } else {
                                    DispatchQueue.main.async {
                                        self.dataMutasi.removeAll()
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
    
    func onChangeDateRange() {
        self.isLoadData = true
        self.showRangeDate = false
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if let range = self.dateRange {
                let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
                let params: [String: Any] = [
                    ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
                    ConstantTransaction.START_DATE : self.formattedDate(range.lowerBound),
                    ConstantTransaction.END_DATE : self.formattedDate(range.upperBound),
                    ConstantTransaction.PAGE_JSON : "0",
                    ConstantTransaction.ACTION : ConstantTransaction.ACTION_MUTASI
                ]
                
                do {
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
                    let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
                    let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
                    let res = self.apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
                    let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
                    if let decryptData = decEn {
                        print("asd data \(decryptData)")
                        if decryptData.contains(ConstantTransaction.CONNECTION_LOST) {
                            DispatchQueue.main.async {
                                self.showAlert = true
                                self.alertMessage = ConstantTransaction.CONNECTION_LOST
                            }
                        } else if decryptData.contains(ConstantTransaction.SERVER_ERROR) {
                            DispatchQueue.main.async {
                                self.showAlert = true
                                self.alertMessage = ConstantTransaction.SERVER_ERROR
                            }
                        } else if decryptData.contains(ConstantTransaction.CONNECTION_ERROR) {
                            DispatchQueue.main.async {
                                self.showAlert = true
                                self.alertMessage = ConstantTransaction.CONNECTION_ERROR
                            }
                        } else {
                            let responseData = decryptData.data(using: .utf8)
                            do {
                                // Parsing JSON
                                let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                                let rc = resjson!["RC"] as? String
                                let rm = resjson!["RM"] as? String
                                if rc == "00" {
                                    if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                        if let dataMutasi = rmData["mutasi"] as? [[String: Any]] {
                                            DispatchQueue.main.async {
                                                self.dataMutasi.removeAll()
                                            }
                                            for data in dataMutasi {
                                                let mutasi = MutasiRekening(jsonDictionary: data)!
                                                DispatchQueue.main.async {
                                                    self.dataMutasi.append(mutasi)
                                                }
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.dataMutasi.removeAll()
                                            }
                                        }
                                        
                                        if let dataSizePerPage = rmData["sizePerPage"] as? Int {
                                            DispatchQueue.main.async {
                                                self.sizePerPage = dataSizePerPage
                                            }
                                        }
                                        
                                        if let dataTotalPages = rmData["totalPages"] as? Int {
                                            DispatchQueue.main.async {
                                                self.totalPages = dataTotalPages
                                            }
                                        }
                                        
                                        if let dataTotalMutasi = rmData["totalMutasi"] as? Int {
                                            DispatchQueue.main.async {
                                                self.totalMutasi = dataTotalMutasi
                                            }
                                        }
                                        
                                        if let dataPage = rmData["page"] as? Int {
                                            DispatchQueue.main.async {
                                                self.page = dataPage + 1
                                            }
                                        }
                                        
                                        if let dataRc = rmData["rc"] as? Int {
                                            DispatchQueue.main.async {
                                                self.rc = dataRc
                                            }
                                        }
                                        
                                        
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showAlert = true
                                        self.alertMessage = rm!
                                    }
                                }
                                
                            } catch {
                                DispatchQueue.main.async {
                                    self.showAlert = true
                                    self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                                }
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert = true
                            self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                    }
                    print("Error : \(error)")
                }
                
            }
            DispatchQueue.main.async {
                self.isLoadData = false
            }
        }
    }
    
    func populateDataMutasi() {
        self.isLoadData = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if let range = self.dateRange {
                let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
                let params: [String: Any] = [
                    ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
                    ConstantTransaction.START_DATE : self.formattedDate(range.lowerBound),
                    ConstantTransaction.END_DATE : self.formattedDate(range.upperBound),
                    ConstantTransaction.PAGE_JSON : self.page.numberString,
                    ConstantTransaction.ACTION : ConstantTransaction.ACTION_MUTASI
                ]
                print("asd param \(params)")
                
                do {
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
                    let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
                    let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
                    let res = self.apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
                    let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
                    if let decryptData = decEn {
                        print("asd data \(decryptData)")
                        if decryptData.contains(ConstantTransaction.CONNECTION_LOST) {
                            DispatchQueue.main.async {
                                self.showAlert = true
                                self.alertMessage = ConstantTransaction.CONNECTION_LOST
                            }
                        } else if decryptData.contains(ConstantTransaction.SERVER_ERROR) {
                            DispatchQueue.main.async {
                                self.showAlert = true
                                self.alertMessage = ConstantTransaction.SERVER_ERROR
                            }
                        } else if decryptData.contains(ConstantTransaction.CONNECTION_ERROR) {
                            DispatchQueue.main.async {
                                self.showAlert = true
                                self.alertMessage = ConstantTransaction.CONNECTION_ERROR
                            }
                        } else {
                            let responseData = decryptData.data(using: .utf8)
                            do {
                                // Parsing JSON
                                let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                                let rc = resjson!["RC"] as? String
                                let rm = resjson!["RM"] as? String
                                if rc == "00" {
                                    if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                        if let dataMutasi = rmData["mutasi"] as? [[String: Any]] {
                                            for data in dataMutasi {
                                                let mutasi = MutasiRekening(jsonDictionary: data)!
                                                DispatchQueue.main.async {
                                                    self.dataMutasi.append(mutasi)
                                                }
                                            }
                                        } 
                                        
                                        if let dataSizePerPage = rmData["sizePerPage"] as? Int {
                                            DispatchQueue.main.async {
                                                self.sizePerPage = dataSizePerPage
                                            }
                                        }
                                        
                                        if let dataTotalPages = rmData["totalPages"] as? Int {
                                            DispatchQueue.main.async {
                                                self.totalPages = dataTotalPages
                                            }
                                        }
                                        
                                        if let dataTotalMutasi = rmData["totalMutasi"] as? Int {
                                            DispatchQueue.main.async {
                                                self.totalMutasi = dataTotalMutasi
                                            }
                                        }
                                        
                                        if let dataPage = rmData["page"] as? Int {
                                            DispatchQueue.main.async {
                                                self.page = dataPage + 1
                                            }
                                        }
                                        
                                        if let dataRc = rmData["rc"] as? Int {
                                            DispatchQueue.main.async {
                                                self.rc = dataRc
                                            }
                                        }
                                        
                                        
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showAlert = true
                                        self.alertMessage = rm!
                                    }
                                }
                                
                            } catch {
                                DispatchQueue.main.async {
                                    self.showAlert = true
                                    self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                                }
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert = true
                            self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                    }
                    print("Error : \(error)")
                }
                
            } else {
                print("asd tidak valid range")
            }
            DispatchQueue.main.async {
                self.isLoadData = false
            }
        }
    }
    
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

}

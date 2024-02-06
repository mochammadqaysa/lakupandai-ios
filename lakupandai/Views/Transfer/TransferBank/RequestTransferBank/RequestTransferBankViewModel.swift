//
//  RequestTransferBankVIewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import Foundation
import SwiftUI


class RequestTransferBankViewModel : ObservableObject {
    @Published var selectedSumber = ""
    @Published var noHPNasabah = ""
    @Published var selectedRekeningTujuan : Bank?
    @Published var listRekeningTujuan : [Bank] = []
    @Published var noRekeningTujuan = ""
    @Published var jumlah = ""
    
    @Published var dataLayanan = ""
    @Published var dataToken = ""
    @Published var dataResponse : [ItemValue] = []
    @Published var dataTransferDari : [ItemValue] = []
    @Published var dataTransferKe : [ItemValue] = []
    
    @Published var showAlert: Bool = false
    @Published var showToastResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    init() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.initData()
            self.isLoading = false
        }
    }
    
    func initData() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN : msisdn,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_LIST_BANK
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
                            if let rmToken = resjson!["token"] as? String {
                                print("ini tokennya gezz : \(rmToken)")
    //                            self.token = rmToken
                            }
                            if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                if let data = rmData["data"] as? [[String: String]] {
                                    print("asd ini datanya gaes 1 : \(data)")
                                    listRekeningTujuan.removeAll()
//                                    dataResponse.removeAll()
//                                    dataTransfer.removeAll()
                                    for rmDatum in data {
                                        if let item = Bank(jsonDictionary: rmDatum) {
                                            self.listRekeningTujuan.append(item)
                                        }
                                    }
                                    self.selectedRekeningTujuan = self.listRekeningTujuan.first
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
    
    
    
    func validateForm() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if self.jumlah.isEmpty {
//
//            } else if self.noHPNasabah.count < 10 {
//
//            } else if self.noRekeningTujuan.count < 10 {
//
//            } else {
//
//            }
            self.requestTransferBank()
            
            self.isLoading = false
        }
    }
    
    func requestTransferBank() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_REQUEST_TRANSFER : msisdn,
            ConstantTransaction.MSISDN_NASABAH_REQUEST_TRANSFER : self.noHPNasabah,
            ConstantTransaction.NOMINAL_REQUEST_TRANSFER : self.jumlah,
            ConstantTransaction.NO_REK_REQUEST_TRANSFER : self.noRekeningTujuan,
            ConstantTransaction.ID_BANK_REQUEST_TRANSFER : self.selectedRekeningTujuan?.bankCode,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_REQUEST_TRANSFER_ANTAR_BANK
        ]
        print("asd params : \(params)")
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
                            if let rmToken = resjson!["token"] as? String {
                                print("ini tokennya gezz : \(rmToken)")
    //                            self.token = rmToken
                                self.dataToken = rmToken
                            }
                            if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                if let data = rmData["data"] as? [[String: String]] {
                                    print("asd ini datanya gaes 1 : \(data)")
                                    dataResponse.removeAll()
                                    dataTransferKe.removeAll()
                                    dataTransferDari.removeAll()
                                    for rmDatum in data {
                                        if let item = ItemValue(jsonDictionary: rmDatum) {
                                            if item.header == "Layanan" {
                                                self.dataLayanan = item.value
                                            }
                                            dataResponse.append(item)
                                        }
                                    }
                                    
                                    let dataRekPenerima = dataResponse.first(where: { find in
                                        return find.header == "No Rek. Penerima"
                                    })
                                    let dataBankPenerima = dataResponse.first(where: { find in
                                        return find.header == "Bank Penerima"
                                    })
                                    let dataNamaPenerima = dataResponse.first(where: { find in
                                        return find.header == "Nama Penerima"
                                    })
                                    let dataJumlah = dataResponse.first(where: { find in
                                        return find.header == "Jumlah"
                                    })
                                    let dataBiayaAdmin = dataResponse.first(where: { find in
                                        return find.header == "Biaya Admin"
                                    })
                                    let dataTotal = dataResponse.first(where: { find in
                                        return find.header == "Total"
                                    })
                                    let dataNoHPPengirim = dataResponse.first(where: { find in
                                        return find.header == "No HP Pengirim"
                                    })
                                    let dataNamaPengirim = dataResponse.first(where: { find in
                                        return find.header == "Nama Pengirim"
                                    })
                                    
                                    if let rekPenerima = dataRekPenerima, let bankPenerima = dataBankPenerima, let namaPenerima = dataNamaPenerima, let jumlah = dataJumlah, let biayaAdmin = dataBiayaAdmin, let total = dataTotal, let noHpPengirim = dataNoHPPengirim, let namaPengirim = dataNamaPengirim {
                                        self.dataTransferKe.append(ItemValue(header: "Nama", value: namaPenerima.value))
                                        self.dataTransferKe.append(ItemValue(header: "Bank Tujuan", value: bankPenerima.value))
                                        self.dataTransferKe.append(ItemValue(header: "No Rek Tujuan", value: rekPenerima.value))
                                        self.dataTransferKe.append(ItemValue(header: "Jumlah", value: jumlah.value))
                                        self.dataTransferKe.append(ItemValue(header: "Biaya Admin", value: biayaAdmin.value))
                                        self.dataTransferKe.append(ItemValue(header: "Total", value: total.value))
                                        
                                        self.dataTransferDari.append(ItemValue(header: "Nama", value: namaPengirim.value))
                                        self.dataTransferDari.append(ItemValue(header: "No HP Nasabah", value: noHpPengirim.value))
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

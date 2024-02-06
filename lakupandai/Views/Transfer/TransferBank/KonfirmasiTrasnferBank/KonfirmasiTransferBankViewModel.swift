//
//  KonfirmasiTransferBankViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import Foundation
import SwiftUI

class KonfirmasiTransferBankViewModel : ObservableObject {
    @Published var token = ""

    @Published var dataLayanan = ""
    @Published var dataResponse : [ItemValue] = []
    @Published var dataTransfer : [ItemValue] = []
    @Published var dataTransferDari : [ItemValue] = []
    @Published var dataTransferKe : [ItemValue] = []
    
    @Published var showAlert: Bool = false
    @Published var showToastResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var detikRequestOtp = 30
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @ObservedObject var apiService = ApiService()
    
    func requestOtp() {
        let requestTarikTunai = UserDefaultsManager.shared.getString(forKey: "temp_body_transfer_bank")
        if let req = requestTarikTunai {
            if req.isEmpty {
                self.showAlert = true
                self.alertMessage = Constant.BELUM_TRANSAKSI
            } else {
                print("ada bozz : \(requestTarikTunai)")
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
                                    if let rmToken = resjson!["token"] as? String {
                                        print("ini tokennya gezz : \(rmToken)")
            //                            self.token = rmToken
                                    }
                                    if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                        if let data = rmData["data"] as? [[String: String]] {
//                                            print("asd ini datanya gaes 1 : \(data)")
//            //                                dataResponse.removeAll()
//            //                                dataSetor.removeAll()
//                                            for rmDatum in data {
//                                                var item = ItemValue(jsonDictionary: rmDatum)!
//                                                if item.header == "Keterangan" {
//                                                    self.alertMessage = item.value
//                                                }
//        //                                        dataResponse.append(ItemValue(jsonDictionary: rmDatum)!)
//        //                                        dataSetor.append(ItemValue(jsonDictionary: rmDatum)!)
//                                            }
//                                            UserDefaultsManager.shared.saveString(resultEnc!, forKey: "temp_body")
//                                            self.showToastResponse = true
//                                            self.nextStep = true
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
            if self.token.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_CONF_CODE_EMPTY
            } else if self.token.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_CONF_CODE_LESS_THAN_6
            } else {
                self.konfirmasiTransferBank()
            }
            self.isLoading = false
        }
    }
    
    func konfirmasiTransferBank() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_TRANSFER_KONFIRMASI : msisdn,
            ConstantTransaction.TOKEN_TRANSFER_KONFIRMASI : self.token,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_TRANSFER_ANTAR_BANK_KONFIRMASI
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

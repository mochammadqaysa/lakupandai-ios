//
//  KonfirmasiTarikTunaiDetailViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 16/01/24.
//

import Foundation
import SwiftUI

class KonfirmasiTarikTunaiDetailViewModel : ObservableObject {
    @Published var pinAgen = ""
    @Published var dataLayanan = ""
    @Published var dataResponse : [ItemValue] = []
    @Published var dataTarikTunai : [ItemValue] = []
    
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
                self.konfirmasiTarikTunai(token: token)
            }
            self.isLoading = false
        }
    }
    
    func konfirmasiTarikTunai(token : String) {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_KONF_TARIK_TUNAI_DETAIL : msisdn,
            ConstantTransaction.TOKEN_KONF_TARIK_TUNAI_DETAIL : token,
            ConstantTransaction.PIN_KONF_TARIK_TUNAI_DETAIL : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_KONFIRMASI_TARIK_TUNAI_DETAIL
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
                                    dataTarikTunai.removeAll()
                                    for rmDatum in data {
                                        if let item = ItemValue(jsonDictionary: rmDatum) {
                                            if item.header == "Layanan" {
                                                self.dataLayanan = item.value
                                            }
                                            dataResponse.append(item)
                                        }
                                    }
                                    
                                    
                                    let dataHP = dataResponse.first(where: { find in
                                        return find.header == "No HP"
                                    })
                                    let dataNama = dataResponse.first(where: { find in
                                        return find.header == "Nama Nasabah"
                                    })
                                    let dataJumlah = dataResponse.first(where: { find in
                                        return find.header == "Jumlah"
                                    })
                                    let dataKeterangan = dataResponse.first(where: { find in
                                        return find.header == "Keterangan"
                                    })
                                    
                                    if let hp = dataHP, let nama = dataNama, let jumlah = dataJumlah, let keterangan = dataKeterangan {
                                        self.dataTarikTunai.append(ItemValue(header: "Nama", value: nama.value))
                                        self.dataTarikTunai.append(ItemValue(header: "No HP", value: hp.value))
                                        self.dataTarikTunai.append(ItemValue(header: "Jumlah", value: jumlah.value))
                                        self.dataTarikTunai.append(ItemValue(header: "Keterangan", value: keterangan.value))
                                    }
                                    
                                    UserDefaultsManager.shared.deleteKey(forKey: "temp_body")
                                    self.nextStep = true
                                    NotificationManager.pushNotification(title: "Tarik tunai berhasil", body: "Tekan untuk melihat transaksi di kotak masuk")
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

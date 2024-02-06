//
//  KonfirmasiTransferBankDetailViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 24/01/24.
//

import Foundation
import SwiftUI

class KonfirmasiTransferBankDetailViewModel : ObservableObject {
    @Published var pinAgen = ""
    
    @Published var dataLayanan = ""
    @Published var dataResponse : [ItemValue] = []
    @Published var dataTransfer : [ItemValue] = []
    
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
                self.konfirmasiTransferLakupandai(token: token)
            }
            
            self.isLoading = false
        }
    }
    
    func konfirmasiTransferLakupandai(token : String) {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_TRANSFER_KONFIRMASI_DETAIL : msisdn,
            ConstantTransaction.TOKEN_TRANSFER_KONFIRMASI_DETAIL : token,
            ConstantTransaction.PIN_TRANSFER_KONFIRMASI_DETAIL : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_TRANSFER_ANTAR_BANK_KONFIRMASI_DETAIL
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
                            }
                            if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                if let data = rmData["data"] as? [[String: String]] {
                                    print("asd ini datanya gaes 1 : \(data)")
                                    dataResponse.removeAll()
                                    dataTransfer.removeAll()
                                    for rmDatum in data {
                                        if let item = ItemValue(jsonDictionary: rmDatum) {
                                            if item.header == "Layanan" {
                                                self.dataLayanan = item.value
                                            }
                                            dataResponse.append(item)
                                        }
                                    }
//
                                    let dataResi = dataResponse.first(where: { find in
                                        return find.header == "No. Resi"
                                    })
                                    let dataWaktu = dataResponse.first(where: { find in
                                        return find.header == "Waktu"
                                    })
                                    let dataBankPenerima = dataResponse.first(where: { find in
                                        return find.header == "Bank Penerima"
                                    })
                                    let dataRekPenerima = dataResponse.first(where: { find in
                                        return find.header == "Rek. Penerima"
                                    })
                                    let dataNamaPenerima = dataResponse.first(where: { find in
                                        return find.header == "Nama Penerima"
                                    })
                                    let dataNominal = dataResponse.first(where: { find in
                                        return find.header == "Nominal"
                                    })
                                    let dataBiayaAdmin = dataResponse.first(where: { find in
                                        return find.header == "Biaya Admin"
                                    })
                                    let dataTotal = dataResponse.first(where: { find in
                                        return find.header == "Total"
                                    })
                                    let dataNamaPengirim = dataResponse.first(where: { find in
                                        return find.header == "Nama Pengirim"
                                    })
                                    let dataNoHPPengirim = dataResponse.first(where: { find in
                                        return find.header == "NoHP Pengirim"
                                    })
                                    let dataStatus = dataResponse.first(where: { find in
                                        return find.header == "Status"
                                    })
                                    
                                    if let resi = dataResi, let waktu = dataWaktu, let bankPenerima = dataBankPenerima, let rekPenerima = dataRekPenerima, let namaPenerima = dataRekPenerima, let nominal = dataNominal, let biayaAdmin = dataBiayaAdmin, let total = dataTotal, let namaPengirim = dataNamaPengirim, let noHPPengirim = dataNoHPPengirim, let status = dataStatus {
                                        self.dataTransfer.append(ItemValue(header: "No. Resi", value: resi.value))
                                        self.dataTransfer.append(ItemValue(header: "Waktu", value: waktu.value))
                                        self.dataTransfer.append(ItemValue(header: "Bank Penerima", value: bankPenerima.value))
                                        self.dataTransfer.append(ItemValue(header: "Rek Penerima", value: rekPenerima.value))
                                        self.dataTransfer.append(ItemValue(header: "Nama Penerima", value: namaPenerima.value))
                                        self.dataTransfer.append(ItemValue(header: "Nominal", value: nominal.value))
                                        self.dataTransfer.append(ItemValue(header: "Biaya Admin", value: biayaAdmin.value))
                                        self.dataTransfer.append(ItemValue(header: "Total", value: total.value))
                                        self.dataTransfer.append(ItemValue(header: "Nama Pengirim", value: namaPengirim.value))
                                        self.dataTransfer.append(ItemValue(header: "No. HP Pengirim", value: noHPPengirim.value))
                                        self.dataTransfer.append(ItemValue(header: "Status", value: status.value))
                                    }
                                    
                                    UserDefaultsManager.shared.deleteKey(forKey: "temp_body_transfer_bank")
                                    self.nextStep = true
                                    NotificationManager.pushNotification(title: "Transfer berhasil", body: "Tekan untuk melihat transaksi di kotak masuk")
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

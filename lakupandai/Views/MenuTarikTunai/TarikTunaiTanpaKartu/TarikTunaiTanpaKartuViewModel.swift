//
//  TarikTunaiTanpaKartuViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import Foundation
import SwiftUI

class TarikTunaiTanpaKartuViewModel : ObservableObject {
    @Published var pinAgen = ""
    @Published var otpNasabah = ""
    @Published var kodeReservasi = ""
    
    @Published var dataResponse : [ItemValue] = []
    @Published var dataTarikTunai : [ItemValue] = []
    
    @Published var showAlert: Bool = false
    @Published var showToastResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    func validateForm() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.kodeReservasi.count == 0 {
                self.showAlert = true
                self.alertMessage = "Silahkan masukan kode reservasi terlebih dahulu"
            } else if self.otpNasabah.count != 6 {
                self.showAlert = true
                self.alertMessage = "OTP harus 6 digit"
            } else if self.pinAgen.count != 6 {
                self.showAlert = true
                self.alertMessage = "PIN agen harus 6 digit"
            } else {
                self.doTarikTunaiTanpaKartu()
            }
            self.isLoading = false
        }
    }
    
    func doTarikTunaiTanpaKartu() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_KONF_TARIK_TUNAI_TANPA_KARTU_DETAIL : msisdn,
            ConstantTransaction.KODE_RESERVASI_TARIK_TUNAI_TP : self.kodeReservasi,
            ConstantTransaction.OTP_TARIK_TUNAI_TP : self.otpNasabah,
            ConstantTransaction.PIN_TARIK_TUNAI_TP : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_TARIK_TUNAI_TP
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
                                            dataResponse.append(item)
                                        }
                                    }
                                    
                                    let dataRefNumber = dataResponse.first(where: { find in
                                        return find.header == "Ref"
                                    })
                                    let dataJumlah = dataResponse.first(where: { find in
                                        return find.header == "Jumlah"
                                    })
                                    let dataNama = dataResponse.first(where: { find in
                                        return find.header == "Nama"
                                    })
                                    let dataRek = dataResponse.first(where: { find in
                                        return find.header == "Norek"
                                    })
                                    let dataStatus = dataResponse.first(where: { find in
                                        return find.header == "Status"
                                    })
                                    
                                    if let refNumber = dataRefNumber, let jumlah = dataJumlah, let nama = dataNama, let rek = dataRek, let status = dataStatus {
                                        self.dataTarikTunai.append(ItemValue(header: "Ref Number", value: refNumber.value))
                                        self.dataTarikTunai.append(ItemValue(header: "Nominal", value: jumlah.value))
                                        self.dataTarikTunai.append(ItemValue(header: "Nama", value: nama.value))
                                        self.dataTarikTunai.append(ItemValue(header: "No Rek", value: rek.value))
                                        self.dataTarikTunai.append(ItemValue(header: "Status", value: status.value))
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

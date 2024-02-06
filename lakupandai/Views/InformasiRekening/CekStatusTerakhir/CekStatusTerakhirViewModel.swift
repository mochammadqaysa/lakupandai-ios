//
//  CekStatusTerakhirViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import Foundation
import SwiftUI

class CekStatusTerakhirViewModel : ObservableObject {
    @Published var pinAgen = ""
    @Published var noTelpon = ""
    @Published var layanan = ""
    @Published var dataResponse: [ItemValue] = []
    @Published var dataStatus: [ItemValue] = []
    
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var nextStep: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var apiService = ApiService()
    
    func validateForm() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.pinAgen.isEmpty || self.noTelpon.isEmpty {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.pinAgen.count < 6 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_PIN_LESS_THAN_6
            } else if self.noTelpon.count < 10 {
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_NUMBER_LESS_THAN_10
            } else {
                self.cekStatusTerakhir()
            }
            
            self.isLoading = false
        }
    }
    
    
    func cekStatusTerakhir() {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_CEK_STATUS_TERAKHIR : msisdn,
            ConstantTransaction.MSISDN_NASABAH_CEK_STATUS_TERAKHIR : self.noTelpon,
            ConstantTransaction.PIN_CEK_STATUS_TERAKHIR : self.pinAgen,
            ConstantTransaction.ACTION : ConstantTransaction.ACTION_CEK_STATUS_TERAKHIR
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
                        if let responseMessage = rm {
                            if let rmString = resjson!["RM"] as? String, let rmData = try JSONSerialization.jsonObject(with: rmString.data(using: .utf8)!, options: []) as? [String: Any] {
                                if let rmData = rmData["data"] as? [[String: String]] {
                                    print("asd ini datanya gaes 1 : \(rmData)")
                                    dataResponse.removeAll()
                                    for rmDatum in rmData {
                                        let dataSaldo = ItemValue(jsonDictionary: rmDatum)!
                                        dataResponse.append(dataSaldo)
                                        if dataSaldo.header == "Layanan" {
                                            self.layanan = dataSaldo.value
                                        }
                                    }
                                    let dataResi = dataResponse.first(where: { find in
                                        return find.header == "No Resi"
                                    })
                                    let dataWaktu = dataResponse.first(where: { find in
                                        return find.header == "Waktu"
                                    })
                                    let dataNominal = dataResponse.first(where: { find in
                                        return find.header == "Nominal"
                                    })
                                    let dataHP = dataResponse.first(where: { find in
                                        return find.header == "No HP"
                                    })
                                    let dataNama = dataResponse.first(where: { find in
                                        return find.header == "Nama"
                                    })
                                    let dtStatus = dataResponse.first(where: { find in
                                        return find.header == "Status"
                                    })
                                    
                                    if let resi = dataResi, let waktu = dataWaktu, let nominal = dataNominal, let hp = dataHP, let nama = dataNama, let status = dtStatus {
                                        self.dataStatus.append(ItemValue(header: "No Resi", value: resi.value))
                                        self.dataStatus.append(ItemValue(header: "Waktu", value: waktu.value))
                                        self.dataStatus.append(ItemValue(header: "Nominal", value: nominal.value))
                                        self.dataStatus.append(ItemValue(header: "No HP", value: hp.value))
                                        self.dataStatus.append(ItemValue(header: "Nama", value: nama.value))
                                        self.dataStatus.append(ItemValue(header: "Status", value: status.value))
                                    }
                                    
                                    
                                    self.nextStep = true
                                }
                            }
//                            self.rmResponse = responseMessage
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

//
//  PembelianViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/11/23.
//

import Foundation
import SwiftUI

class PembelianViewModel : ObservableObject {
    
    @Published var showNotificationDetail: Bool = false
    
    @Published var selectedLayanan: String = "" {
        didSet {
            onChangeLayanan(newValue: selectedLayanan)
        }
    }
    @Published var selectedListSubLayanan: [[String : String]] = []
    @Published var selectedSubLayanan: String = "" {
        didSet {
            onChangeSubLayanan(newValue: selectedSubLayanan)
        }
    }
    @Published var selectedProductCode: String = ""
    @Published var nomorPonsel: String = ""
    @Published var nomorPelanggan: String = ""
    @Published var selectedNominal: String = ""
    
    @Published var selectedMetodePembayaran: String = "Debit"
    @Published var rekeningPonsel: String = ""
    
    @Published var dataResponse: [ItemValue] = []
    @Published var dataForm: [String : Any] = [:]
    @Published var dataToken: String = ""
    @Published var nextStep = false
    
    @Published var layananPos: Int?
    @Published var listLayanan: [Any] = Array<Any>()
    @Published var listSubLayanan: [Any] = Array<Any>()
    @Published var listDenom: [String] = []
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @ObservedObject var apiService = ApiService()
    
    init() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            executeLayanan(layanan: "pembayaran")
            self.initLayanan(layanan: "pembelian")
            self.isLoading = false
        }
    }
    
    func onChangeLayanan(newValue: String) {
        print("ini new Value : \(newValue)")
        for (index, item) in self.listLayanan.enumerated() {
            if item as? String == newValue {
                print("pos: \(index)")
                layananPos = index
                selectedListSubLayanan = self.listSubLayanan[layananPos!] as! [[String : String]]
                selectedSubLayanan = self.selectedListSubLayanan.first!["productName"]!
                selectedProductCode = self.selectedListSubLayanan.first!["productCode"]!
                
                var denoms : String = selectedListSubLayanan.first!["denom"]! as String
                print(self.selectedListSubLayanan.first!["denom"])
                let sortedIntArray = denoms.components(separatedBy: ",").compactMap { Int($0) }.sorted()
                listDenom = sortedIntArray.compactMap { String($0) }
                selectedNominal = listDenom.first! as String
                break
            }
        }
    }
    
    func onChangeSubLayanan(newValue: String) {
        for (index, item) in self.selectedListSubLayanan.enumerated() {
            if item["productName"] == newValue {
                print("asd ini onchange Sub layanan \(item)")
                var denom : String = item["denom"]! as String
                let sortedIntArray = denom.components(separatedBy: ",").compactMap { Int($0) }.sorted()
                listDenom = sortedIntArray.compactMap { String($0) }
                selectedNominal = listDenom.first! as String
                break
            }
        }
    }
    
    func initLayanan(layanan: String)  {
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN: msisdn,
            ConstantTransaction.TIPE: layanan,
            ConstantTransaction.ACTION: ConstantTransaction.ACTION_GET_MENU,
        ]
        
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            let cleanedResponseString = try decEn!.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
            let responseData = cleanedResponseString.data(using: .utf8)
            print("Response: \(cleanedResponseString)")
            
            do {
                // Parsing JSON
                let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                let rc = resjson!["RC"] as? String
                print("RC value: \(rc)")
                if rc == "00" {
                    if layanan == "pembelian" {
                        listLayanan.removeAll()
                        listSubLayanan.removeAll()
                        
                        if let rmData = resjson!["RM"] as? [String: Any], let data = rmData["data"] as? [String: [[String: String]]] {
                            listLayanan = Array(data.keys)
                            listSubLayanan = data.values.compactMap { $0.map { $0 } }
                            selectedLayanan = listLayanan.first as! String
                            selectedListSubLayanan = self.listSubLayanan[layananPos!] as! [[String : String]]
                            
//                            var denoms : String = selectedListSubLayanan.first!["denom"]! as String
//                            listDenom = denoms.components(separatedBy: ",").compactMap { $0 }
//                            selectedNominal = listDenom.first as! String
                            
                        }
                        print("asd list layanan : \(listLayanan)")
                        print("asd list sub layanan : \(listSubLayanan)")
                        print("asd denom : \(listDenom)")
                    }
                }else{
                    
                }
                
            } catch {
                print("Error parsing JSON: \(error)")
            }
        } catch {
            showAlert = true
            alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
        }
        
        
    }
    
    func validateForm() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.selectedMetodePembayaran == "Debit" && self.rekeningPonsel.isEmpty {
                self.isLoading = false
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.selectedLayanan.contains("Telepon") && self.nomorPonsel.isEmpty {
                self.isLoading = false
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else if self.selectedLayanan.contains("PLN") && self.nomorPelanggan.isEmpty {
                self.isLoading = false
                self.showAlert = true
                self.alertMessage = ConstantError.ALERT_FIELD_EMPTY
            } else {
                self.doPembelian()
                self.isLoading = false
            }
        }
    }
    
    func doPembelian() {
        var json : [String : Any] = [:]
        let noHpAgen = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        do {
            if selectedMetodePembayaran == "Debit" {
                json.updateValue(self.selectedProductCode, forKey: ConstantTransaction.KODE_PRODUK)
                if selectedLayanan.contains("Telepon") {
                    json.updateValue(self.nomorPonsel, forKey: ConstantTransaction.ID_PELANGGAN)
                } else {
                    json.updateValue(self.nomorPelanggan, forKey: ConstantTransaction.ID_PELANGGAN)
                }
                json.updateValue(self.rekeningPonsel, forKey: ConstantTransaction.MSISDN_NASABAH)
                json.updateValue(noHpAgen, forKey: ConstantTransaction.MSISDN_AGEN_LOGIN)
                json.updateValue(self.selectedNominal, forKey: ConstantTransaction.DENOM)
                json.updateValue(ConstantTransaction.ACTION_PEMBELIAN, forKey: ConstantTransaction.ACTION)
            } else {
                json.updateValue(self.selectedProductCode, forKey: ConstantTransaction.KODE_PRODUK)
                if selectedLayanan.contains("Telepon") {
                    json.updateValue(self.nomorPonsel, forKey: ConstantTransaction.ID_PELANGGAN)
                } else {
                    json.updateValue(self.nomorPelanggan, forKey: ConstantTransaction.ID_PELANGGAN)
                }
                json.updateValue(noHpAgen, forKey: ConstantTransaction.MSISDN_AGEN_LOGIN)
                json.updateValue(self.selectedNominal, forKey: ConstantTransaction.DENOM)
                json.updateValue(ConstantTransaction.ACTION_PEMBELIAN, forKey: ConstantTransaction.ACTION)
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: json,options: .sortedKeys) else { return }
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            
            let cleanedResponseString = decEn!.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
            let responseData = cleanedResponseString.data(using: .utf8)
            print("Response: \(cleanedResponseString)")
            if cleanedResponseString.contains(ConstantTransaction.CONNECTION_LOST) {
                showAlert = true
                alertMessage = ConstantTransaction.CONNECTION_LOST
            } else if cleanedResponseString.contains(ConstantTransaction.SERVER_ERROR) {
                showAlert = true
                alertMessage = ConstantTransaction.SERVER_ERROR
            } else if cleanedResponseString.contains(ConstantTransaction.CONNECTION_ERROR) {
                showAlert = true
                alertMessage = ConstantTransaction.CONNECTION_ERROR
            } else {
                do {
                    let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                    let rc = resjson!["RC"] as? String
                    let rmString = resjson!["RM"] as? String
                    print("RC value: \(rc!)")
                    if rc == "00"{
                        let rmData = rmString!.data(using: .utf8)
                        let rmJson = try JSONSerialization.jsonObject(with: rmData!, options: []) as? [String: Any]
                        
                        if let rmToken = resjson!["token"] as? String {
                            print("ini tokennya gezz : \(rmToken)")
                            dataToken = rmToken
                        }
                        if let rmData = rmJson!["data"] as? [[String: String]] {
                            print("asd ini datanya gaes 1 : \(rmData)")
                            dataResponse.removeAll()
                            for rmDatum in rmData {
                                let item : ItemValue = ItemValue(jsonDictionary: rmDatum)!
                                if item.header == "Desc" {
                                    if item.value.contains(",") {
                                        let value : String = item.value
                                    } else {
                                        let value : String = item.value
                                    }
                                } else if item.header == "otp" {
                                    let otp : String = item.value
                                } else {
                                    dataResponse.append(item)
                                }
                            }
                            dataForm = json
                            self.nextStep = true
                        }
                    }else {
                        showAlert = true
                        alertMessage = rmString!
                    }
                } catch {
                    showAlert = true
                    alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                    print("Error parsing JSON: \(error)")
                }
            }
        } catch {
            showAlert = true
            alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            print("Error : \(error)")
        }
    }
}

//
//  PembayaranViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/11/23.
//

import SwiftUI
import Foundation

class PembayaranViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showNotificationDetail: Bool = false
    @Published var selectedLayanan: String = "" {
        didSet {
            onChangeLayanan(newValue: selectedLayanan)
        }
    }
    @Published var selectedListSubLayanan: [[String : String]] = []
    @Published var selectedSubLayanan: String = ""
    @Published var selectedProductCode: String = ""
    @Published var idPembayaran: String = ""
    @Published var tahunTagihan: String = ""
    @Published var selectedJumlahBulan: String = "1"
    @Published var selectedMetodePembayaran: String = "Debit"
    @Published var rekeningPonsel: String = ""
    @Published var layananPos: Int?
    @Published var listLayanan: [Any] = Array<Any>()
    @Published var listSubLayanan: [Any] = Array<Any>()
    
    @Published var dataResponse: [ItemValue] = []
    @Published var dataForm: [String : Any] = [:]
    @Published var dataToken: String = ""
    
    @Published var nextStep = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @ObservedObject var apiService = ApiService()
    
    init() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.initLayanan(layanan: "pembayaran")
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
//                disableSubLayanan = false
//                listSub = globalObject.subLayanan[pos!] as! [[String : String]]
//                selectedSubLayanan = listSub.first!["productName"]!
//                productCode = listSub.first!["productCode"]!
                break
            }
        }
    }
    
    func initLayanan(layanan: String)  {
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN: "tonys7777",
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
            let cleanedResponseString = decEn!.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
            let responseData = cleanedResponseString.data(using: .utf8)
            print("Response: \(cleanedResponseString)")
            
            do {
                // Parsing JSON
                let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                let rc = resjson!["RC"] as? String
                print("RC value: \(rc)")
                if rc == "00" {
                    if layanan == "pembayaran" {
                        listLayanan.removeAll()
                        listSubLayanan.removeAll()
                        
                        if let rmData = resjson!["RM"] as? [String: Any], let data = rmData["data"] as? [String: [[String: String]]] {
                            listLayanan = Array(data.keys)
                            listSubLayanan = data.values.compactMap { $0.map { $0 } }
                            selectedLayanan = listLayanan.first as! String
                            selectedListSubLayanan = self.listSubLayanan[layananPos!] as! [[String : String]]
                            
                        }
                        print("asd list layanan : \(listLayanan)")
                        print("asd list sub layanan : \(listSubLayanan)")
                    }else{
                        
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
            if self.selectedLayanan == "" {
                self.showAlert = true
                self.alertMessage = "Silakan pilih layanan"
                self.isLoading = false
            } else if self.selectedMetodePembayaran == "Debit" && self.rekeningPonsel.isEmpty {
                self.showAlert = true
                self.alertMessage = "Mohon lengkapi formulir yang kosong"
                self.isLoading = false
            } else if self.idPembayaran.isEmpty {
                self.showAlert = true
                self.alertMessage = "Mohon lengkapi formulir yang kosong"
                self.isLoading = false
            } else{
                self.isLoading = false
                self.doPembayaran()
            }
        }
    }
    
    func doPembayaran() {
        var json : [String : Any] = [:]
        let noHpAgen = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        do {
            json.updateValue(self.selectedProductCode, forKey: ConstantTransaction.KODE_PRODUK)
            if self.selectedSubLayanan == "BPJS Kesehatan" {
                json.updateValue(self.idPembayaran + String(format: "%02d", Int(self.selectedJumlahBulan)!), forKey: ConstantTransaction.ID_PELANGGAN)
            } else if selectedLayanan == "PBB" {
                json.updateValue(self.idPembayaran + self.tahunTagihan, forKey: ConstantTransaction.ID_PELANGGAN)
            } else {
                json.updateValue(self.idPembayaran, forKey: ConstantTransaction.ID_PELANGGAN)
            }
            
            if self.selectedMetodePembayaran == "Debit" {
                json.updateValue(self.rekeningPonsel, forKey: ConstantTransaction.MSISDN_NASABAH)
                json.updateValue(noHpAgen! as String, forKey: ConstantTransaction.MSISDN_AGEN_LOGIN)
                json.updateValue(ConstantTransaction.ACTION_PEMBAYARAN, forKey: ConstantTransaction.ACTION)
            }else {
                json.updateValue(noHpAgen! as String, forKey: ConstantTransaction.MSISDN_AGEN_LOGIN)
                json.updateValue(ConstantTransaction.ACTION_PEMBAYARAN, forKey: ConstantTransaction.ACTION)
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: json,options: .sortedKeys) else { return }
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            
            let cleanedResponseString = decEn!.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
            let responseData = cleanedResponseString.data(using: .utf8)
            print("Response: \(cleanedResponseString)")
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
                            dataResponse.append(ItemValue(jsonDictionary: rmDatum)!)
                        }
                        dataForm = json
                        self.nextStep = true
                    }
                }else {
                    showAlert = true
                    alertMessage = rmString!
                }
            }catch {
                showAlert = true
                alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                print("Error parsing JSON: \(error)")
            }
        } catch {
            showAlert = true
            alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            print("Error : \(error)")
        }
    }
}

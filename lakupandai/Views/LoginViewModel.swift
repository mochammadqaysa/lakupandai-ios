//
//  LoginViewModel.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/12/23.
//

import Foundation
import SwiftUI

class LoginViewModel : ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var responseCode: String = ""
    @Published var rememberMe: Bool = false
    @Published var isLoading: Bool = false
    @Published var isLogin: Bool = false
    @ObservedObject var apiService = ApiService()
    
    init() {
        if let username = UserDefaultsManager.shared.getString(forKey: "username"), let password = UserDefaultsManager.shared.getString(forKey: "password"), let remember = UserDefaultsManager.shared.getString(forKey: "rememberMe"), let rememberMe = Bool(remember) {
            self.username = username
            self.password = password
            self.rememberMe = rememberMe
        }
    }
    
    func validateForm(){
        if username.isEmpty && password.isEmpty {
            showAlert = true
            alertMessage = ConstantError.ALERT_FIELD_EMPTY
        } else if username.count < 1{
            showAlert = true
            alertMessage = ConstantError.ALERT_USERNAME_EMPTY
        } else if password.count < 1 {
            showAlert = true
            alertMessage = ConstantError.ALERT_PIN_LESS_THAN_6
        }else{
            isLoading = true
            UserDefaultsManager.shared.saveString(password, forKey: Constant.MY_PREF_PIN)
            UserDefaultsManager.shared.saveString(username, forKey: Constant.My_PREF_MSISDN_AGEN)
            UserDefaultsManager.shared.saveString(username, forKey: Constant.My_PREF_MSISDN_AGEN_LOGIN)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.doLogin()
                self.isLoading = false
            }
        }
    }
    
    func doLogin() {
        let params: [String: Any] = [
//            ConstantTransaction.PIN_LOGIN: "123456",
//            ConstantTransaction.MSISDN_AGEN: "tonys7777",
            ConstantTransaction.PIN_LOGIN: self.password,
            ConstantTransaction.MSISDN_AGEN: self.username,
            ConstantTransaction.IMEI_LOGIN: "f41b514af2692ef6",
            ConstantTransaction.TOKEN: "egv4Hlwwk0o:APA91bEyRTEJ-6kYx-k4TZz06EKwiUTAOvlrxz8lt0VDI52uyUHdzEs2nU7RoOZUUOnpxtAh4pX1sED5xGZRD7yiSPqgJunPLz9IHp5oPkpJd-PgM5hjcilycwMPYnLmbFFNvtIDjVYI",
            ConstantTransaction.ACTION: "login"
        ]
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
            let jsonString = String(data: jsonData, encoding: .utf8)
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
                    do {
                        // Parsing JSON
                        let responseData = decryptData.data(using: .utf8)
                        let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                        let rc = resjson!["RC"] as? String
                        let rmString = resjson!["RM"] as? String
                        if rc! == "00" {
                            if let rmData = rmString?.data(using: .utf8),
                               let rmJson = try JSONSerialization.jsonObject(with: rmData, options: []) as? [String: Any] {
                                let data : [[String: Any]]? = rmJson["data"] as? [[String : Any]]
                                if let unwrappedData = data {
                                    for dataRM in unwrappedData {
                                        // Access values from each dictionary item
                                        if let header = dataRM["header"] as? String,
                                           let value = dataRM["value"] as? String {
                                            if header == "Agent Id"{
                                                UserDefaultsManager.shared.saveString(value, forKey: ConstantTransaction.USER_SESSION_AGENT_ID)
                                            } else if header == "Agent Name" {
                                                UserDefaultsManager.shared.saveString(value, forKey: ConstantTransaction.USER_SESSION_AGENT_NAME)
                                            }
            //                                print("Header: \(header), Value: \(value)")
                                        }
                                    }
                                    doInit()
                                } else {
                                    print("Data is nil or not an array.")
                                }
                            }
                        }else if rc! == "70" {
                            showAlert = true
                            alertMessage = rmString!
            //                navigateChangePin = true
                        }else {
                            
                        }
                        print("RC value: \(rc!)")
                    } catch {
                        showAlert = true
                        alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
                        print("Error parsing JSON: \(error)")
                        
                    }
                }
            } else {
                showAlert = true
                alertMessage = ConstantError.ALERT_SERVER_NOT_RESPONSE
            }
            
            
        } catch {
            showAlert = true
            alertMessage = ConstantError.ALERT_SERVER_NOT_RESPONSE
            print("Error Hit Server: \(error)")
        }
        
    }
    
    func doInit(){
        let msisdn = UserDefaultsManager.shared.getString(forKey: Constant.My_PREF_MSISDN_AGEN)
        let params: [String: Any] = [
            ConstantTransaction.MSISDN_AGEN_LOGIN: msisdn,
            ConstantTransaction.ACTION: ConstantTransaction.ACTION_INIT,
            "info": "getImage",
        ]
        
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params,options: .sortedKeys) else { return }
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            let resultEnc = try TripleDES.encryptStringUsing3DES(input: String(data: jsonData, encoding: .utf8) ?? "")
            
            let timeout : TimeInterval = TimeInterval(ConstantTransaction.TimeOutConnection)
            let res = apiService.httpRequestPost(url: ConstantTransaction.URL, json: resultEnc!, timeout: timeout)
            let decEn = try TripleDES.decryptStringUsing3DES(input: res ?? "")
            
            if let decryptData = decEn {
                let responseData = decryptData.data(using: .utf8)
                do {
                    // Parsing JSON
                    let resjson = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
                    let rc = resjson!["RC"] as? String
                    let rmString = resjson!["RM"] as? String
                    self.responseCode = rc!
                    if rc! == "00" {
                        if let rmData = rmString?.data(using: .utf8),
                           let rmJson = try JSONSerialization.jsonObject(with: rmData, options: []) as? [String: Any] {
                            if let dataDictionary = rmJson["data"] as? [String: Any] {
                                if let imageSliderArray = dataDictionary["image_slider"] as? [[String: Any]] {
                                    print("length slider : \(imageSliderArray.count)")
                                    UserDefaultsManager.shared.saveString(String(imageSliderArray.count), forKey: ConstantTransaction.USER_SESSION_SLIDER_COUNT)
                                    let imageCache = ImageCache.getInstance()
                                    imageCache.initializeCache()
                                    var i = 1
                                    for sliderItem in imageSliderArray {
                                        if let base64Value = sliderItem["base64"] as? String {
                                            imageCache.addImageToWarehouse(key: "image_slider\(i)", value: getBitmap(base64Value)!)
                                        }
                                        i += 1
                                    }
                                }
                            }
                        }
                        // redirect login
                        if self.rememberMe {
                            UserDefaultsManager.shared.saveString(self.username, forKey: "username")
                            UserDefaultsManager.shared.saveString(self.password, forKey: "password")
                            UserDefaultsManager.shared.saveString(self.rememberMe.description, forKey: "rememberMe")
                        } else {
                            UserDefaultsManager.shared.saveString("", forKey: "username")
                            UserDefaultsManager.shared.saveString("", forKey: "password")
                            UserDefaultsManager.shared.saveString(self.rememberMe.description, forKey: "rememberMe")
                        }
                        self.isLogin = true
                    }else {
                    }
                    print("RC value: \(rc!)")
                } catch {
                    showAlert = true
                    alertMessage = "Gagal membaca reespon server, mohon coba beberapa saat lagi"
                    print("Error parsing JSON: \(error)")
                }
            } else {
                showAlert = true
                alertMessage = ConstantError.ALERT_FAILED_READ_RESPONSE
            }
        }catch {
            showAlert = true
            alertMessage = "Gagal membaca reespon server, mohon coba beberapa saat lagi"
        }
        
        
    }
    
    func getBitmap(_ base64String: String) -> UIImage? {
        // Convert base64String to Data
        guard let decodedData = Data(base64Encoded: base64String) else {
            return nil
        }
        
        // Convert Data to UIImage
        guard let image = UIImage(data: decodedData) else {
            return nil
        }
        
        return image
    }
}

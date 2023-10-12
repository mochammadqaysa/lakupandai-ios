//
//  ApiService.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import Foundation
import Security
import SwiftUI
import DeviceCheck

class ApiService: NSObject, ObservableObject, URLSessionDelegate {
    
    func httpRequestPost(url: String, json: String, timeout: TimeInterval) -> String {
        var strResponse = ""
        
        do {
            let trustAllCerts = TrustManager()
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = timeout
            
            let session = URLSession(configuration: sessionConfig, delegate: trustAllCerts, delegateQueue: nil)
            guard let requestUrl = URL(string: url) else {
                return strResponse
            }
            
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            request.setValue("android|", forHTTPHeaderField: "Authorization")
            request.setValue(String(describing: getDatetime()), forHTTPHeaderField: "Authorization")
            request.httpBody = json.data(using: .utf8)
            
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request) { (data, response, error) in
                defer {
                    semaphore.signal()
                }
                
                if let error = error {
                    strResponse = error.localizedDescription
                    return
                }
                
                if let data = data {
                    strResponse = String(data: data, encoding: .utf8) ?? ""
                }
            }
            
            task.resume()
            semaphore.wait()
            
        } catch {
            strResponse = error.localizedDescription
        }
        
        return strResponse
    }
    
    func getDatetime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}

class TrustManager: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}


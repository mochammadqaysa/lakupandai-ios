//
//  TripleDES.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import Foundation
import CommonCrypto
import Security


class TripleDES {
    static let secretKey = "0102030405060708090A0B0C0D0E0F"
    static let desEncryptionScheme = "3des"
    static let unicodeFormat = String.Encoding.utf8
    
    static func encryptStringUsing3DES(input: String) throws -> String? {
        let inputData = input.data(using: .utf8)
        let keyData = secretKey.data(using: .utf8)
        let cryptLength = size_t(inputData!.count + kCCBlockSize3DES)
        var cryptData = Data(count: cryptLength)
        
        let keyLength = size_t(kCCKeySize3DES)
        
        let operation = CCOperation(kCCEncrypt)
        let algoritm = CCAlgorithm(kCCAlgorithm3DES)
        let options = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            inputData!.withUnsafeBytes { dataBytes in
                keyData!.withUnsafeBytes { keyBytes in
                    CCCrypt(operation,
                             algoritm,
                             options,
                             keyBytes.baseAddress,
                             keyLength,
                             nil,
                             dataBytes.baseAddress,
                             inputData!.count,
                             cryptBytes.baseAddress,
                             cryptLength,
                             &numBytesEncrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.count = numBytesEncrypted
            let encryptedString = cryptData.base64EncodedString()
            return encryptedString
        } else {
            return nil
        }
    }

    static func decryptStringUsing3DES(input: String) throws -> String? {
        guard let inputData = Data(base64Encoded: input) else {
            return nil
        }
        let keyData = secretKey.data(using: .utf8)
        let cryptLength = size_t(inputData.count + kCCBlockSize3DES)
        var cryptData = Data(count: cryptLength)
        
        let keyLength = size_t(kCCKeySize3DES)
        
        let operation = CCOperation(kCCDecrypt)
        let algoritm = CCAlgorithm(kCCAlgorithm3DES)
        let options = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode)
        
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            inputData.withUnsafeBytes { dataBytes in
                keyData!.withUnsafeBytes { keyBytes in
                    CCCrypt(operation,
                             algoritm,
                             options,
                             keyBytes.baseAddress,
                             keyLength,
                             nil,
                             dataBytes.baseAddress,
                             inputData.count,
                             cryptBytes.baseAddress,
                             cryptLength,
                             &numBytesDecrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.count = numBytesDecrypted
            if let decryptedString = String(data: cryptData, encoding: .utf8) {
                return decryptedString
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func encrypt(_ unencryptedString: String) -> String? {
        let encryptedString: String?
        let keyLength = size_t(kCCKeySize3DES)
        let options = CCOptions(kCCOptionPKCS7Padding)
        let keyData = secretKey.data(using: unicodeFormat)!
        let plainTextData = unencryptedString.data(using: unicodeFormat)!
        var encryptedData = Data(count: plainTextData.count + kCCBlockSize3DES)
        var encryptedLength: size_t = 0
        
        let cryptStatus = keyData.withUnsafeBytes { keyBytes in
            plainTextData.withUnsafeBytes { plainTextBytes in
                encryptedData.withUnsafeMutableBytes { encryptedBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithm3DES),
                        options,
                        keyBytes.baseAddress, keyLength,
                        nil,
                        plainTextBytes.baseAddress, plainTextBytes.count,
                        encryptedBytes.baseAddress, encryptedBytes.count,
                        &encryptedLength
                    )
                }
            }
        }
        
        if cryptStatus == CCCryptorStatus(kCCSuccess) {
            encryptedData.count = encryptedLength
            let base64String = encryptedData.base64EncodedString(options: [])
            encryptedString = base64String
        } else {
            encryptedString = nil
        }
        
        return encryptedString
    }
    
    static func decrypt(_ encryptedString: String) -> String? {
        let decryptedString: String?
        let keyLength = size_t(kCCKeySize3DES)
        let options = CCOptions(kCCOptionPKCS7Padding)
        let keyData = secretKey.data(using: unicodeFormat)!
        let encryptedData = Data(base64Encoded: encryptedString)!
        var decryptedData = Data(count: encryptedData.count + kCCBlockSize3DES)
        var decryptedLength: size_t = 0
        
        let cryptStatus = keyData.withUnsafeBytes { keyBytes in
            encryptedData.withUnsafeBytes { encryptedBytes in
                decryptedData.withUnsafeMutableBytes { decryptedBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithm3DES),
                        options,
                        keyBytes.baseAddress, keyLength,
                        nil,
                        encryptedBytes.baseAddress, encryptedBytes.count,
                        decryptedBytes.baseAddress, decryptedBytes.count,
                        &decryptedLength
                    )
                }
            }
        }
        
        if cryptStatus == CCCryptorStatus(kCCSuccess) {
            decryptedData.count = decryptedLength
            let decryptedStringData = decryptedData.subdata(in: 0..<decryptedLength)
            decryptedString = String(data: decryptedStringData, encoding: unicodeFormat)
        } else {
            decryptedString = nil
        }
        
        return decryptedString
    }
}


/// Extension for Symmetric Encryption and Decryption with DES, 3DES, AES algorithms
extension String {
    
    /// Encrypts message with DES algorithm
    func desEncrypt(key:String) -> String? {
        
        return symetricEncrypt(key: key, blockSize: kCCBlockSizeDES, keyLength: size_t(kCCKeySizeDES), algorithm: UInt32(kCCAlgorithmDES))
    }
    
    /// Encrypts message with 3DES algorithm
    func tripleDesEncrypt(key:String) -> String? {
        
        return symetricEncrypt(key: key, blockSize: kCCBlockSize3DES, keyLength: size_t(kCCKeySize3DES), algorithm: UInt32(kCCAlgorithm3DES))
    }
    
    /// Encrypts message with AES 128 algorithm
    func aes128Encrypt(key:String) -> String? {
        
        return symetricEncrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES128), algorithm: UInt32(kCCAlgorithmAES128))
    }
    
    /// Encrypts message with AES algorithm with 256 key length
    func aesEncrypt(key:String) -> String? {
        
        return symetricEncrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES256), algorithm: UInt32(kCCAlgorithmAES))
    }
    
    /// Encrypts a message with symmetric algorithm
    func symetricEncrypt(key: String, blockSize: Int, keyLength: size_t, algorithm: CCAlgorithm, options: Int = kCCOptionECBMode) -> String? {
        let keyData = key.data(using: .utf8)! as NSData
        let data = self.data(using: .utf8)! as NSData
        
        let cryptData = NSMutableData(length: Int(data.length) + blockSize)!
        
        let operation: CCOperation = UInt32(kCCEncrypt)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algorithm,
                                  UInt32(options),
                                  keyData.bytes, keyLength,
                                  nil,
                                  data.bytes, data.length,
                                  cryptData.mutableBytes, cryptData.length,
                                  &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.length = Int(numBytesEncrypted)
            let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
            let mergedString = base64cryptString.components(separatedBy: .whitespacesAndNewlines).joined()
            return mergedString
        } else {
            return nil
        }
    }

    
    /// Decrypts message with DES algorithm
    func desDecrypt(key:String) -> String? {
        
        return symetricDecrypt(key: key, blockSize: kCCBlockSizeDES, keyLength: size_t(kCCKeySizeDES), algorithm: UInt32(kCCAlgorithmDES))
    }
    
    /// Decrypts message with 3DES algorithm
    func tripleDesDecrypt(key:String) -> String? {
        
        return symetricDecrypt(key: key, blockSize: kCCBlockSize3DES, keyLength: size_t(kCCKeySize3DES), algorithm: UInt32(kCCAlgorithm3DES))
    }
    
    /// Decrypts message with AES 128 algorithm
    func aes128Decrypt(key:String) -> String? {
        
        return symetricDecrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES128), algorithm: UInt32(kCCAlgorithmAES128))
    }
    
    /// Decrypts message with AES algorithm with 256 key length
    func aesDecrypt(key:String) -> String? {
        
        return symetricDecrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES256), algorithm: UInt32(kCCAlgorithmAES))
    }

    /// Decrypts a message with symmetric algorithm
    func symetricDecrypt(key: String, blockSize: Int, keyLength: size_t, algorithm: CCAlgorithm, options: Int = kCCOptionECBMode) -> String? {
        if let keyData = key.data(using: .utf8),
           let mergedData = NSData(base64Encoded: self.components(separatedBy: .whitespacesAndNewlines).joined(), options: .ignoreUnknownCharacters),
           let data = NSMutableData(length: Int(mergedData.count) + blockSize) {
            
            let operation: CCOperation = UInt32(kCCDecrypt)
            var numBytesEncrypted: size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algorithm,
                                      UInt32(options),
                                      (keyData as NSData).bytes, keyLength,
                                      nil,
                                      mergedData.bytes, mergedData.count,
                                      data.mutableBytes, data.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                data.length = Int(numBytesEncrypted)
                let decryptedData = Data(referencing: data)
                if let decryptedString = String(data: decryptedData, encoding: .utf8) {
                    return decryptedString
                }
            }
        }
        return nil
    }
}

//
//  Bank.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 23/01/24.
//

import Foundation

struct Bank: Identifiable, Hashable {
    var id = UUID()
    var bankCode: String
    var bankName: String
    
    init(id: UUID = UUID(), bankCode: String, bankName: String) {
        self.id = id
        self.bankCode = bankCode
        self.bankName = bankName
    }
    
    init?(jsonDictionary: [String: String]) {
        guard let bankCode = jsonDictionary["bankCode"],
              let bankName = jsonDictionary["bankName"]
        else {
            return nil
        }

        self.init(bankCode: bankCode, bankName: bankName)
    }
}

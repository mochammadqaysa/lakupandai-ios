//
//  MutasiRekening.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 03/01/24.
//

import Foundation

struct MutasiRekening: Identifiable, Equatable {
    var idView = UUID()
    var id: Int
    var amount: Int
    var crTime: String
    var description: String
    var feeAgen: Int
    var feeBank: Int
    var idNotif: Int
    var nasabah: String
    var resi: String
    var totalAmount: String
    var totalAmountNReal: Int
    
    init(idView: UUID = UUID(), id: Int, amount: Int, crTime: String, description: String, feeAgen: Int, feeBank: Int, idNotif: Int, nasabah: String, resi: String, totalAmount: String, totalAmountNReal: Int) {
        self.idView = idView
        self.id = id
        self.amount = amount
        self.crTime = crTime
        self.description = description
        self.feeAgen = feeAgen
        self.feeBank = feeBank
        self.idNotif = idNotif
        self.nasabah = nasabah
        self.resi = resi
        self.totalAmount = totalAmount
        self.totalAmountNReal = totalAmountNReal
    }
    
    init?(jsonDictionary: [String: Any]) {
        guard let id = jsonDictionary["id"] as? Int,
              let amount = jsonDictionary["Amount"] as? Int,
              let crTime = jsonDictionary["crTime"] as? String,
              let description = jsonDictionary["description"] as? String,
              let feeAgen = jsonDictionary["feeAgen"] as? Int,
              let feeBank = jsonDictionary["feeBank"] as? Int,
              let idNotif = jsonDictionary["id_notif"] as? Int,
              let nasabah = jsonDictionary["nasabah"] as? String,
              let resi = jsonDictionary["resi"] as? String,
              let totalAmount = jsonDictionary["totalAmount"] as? String,
              let totalAmountNReal = jsonDictionary["totalAmountNReal"] as? Int
        else {
            return nil
        }

        self.init(id: id, amount: amount, crTime: crTime, description: description, feeAgen: feeAgen, feeBank: feeBank, idNotif: idNotif, nasabah: nasabah, resi: resi, totalAmount: totalAmount, totalAmountNReal: totalAmountNReal)
    }
    
    static func == (lhs: MutasiRekening, rhs: MutasiRekening) -> Bool {
        return lhs.id == rhs.id
            && lhs.amount == rhs.amount
            && lhs.crTime == rhs.crTime
            && lhs.description == rhs.description
            && lhs.feeAgen == rhs.feeAgen
            && lhs.feeBank == rhs.feeBank
            && lhs.idNotif == rhs.idNotif
            && lhs.nasabah == rhs.nasabah
            && lhs.resi == rhs.resi
            && lhs.totalAmount == rhs.totalAmount
            && lhs.totalAmountNReal == rhs.totalAmountNReal
    }
    
}

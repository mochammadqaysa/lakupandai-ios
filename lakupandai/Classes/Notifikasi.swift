//
//  Notification.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 07/02/24.
//

import Foundation

struct Notifikasi: Identifiable, Equatable {
    var id = UUID()
    var id_notif: Int
    var date: String
    var feeBank: Int
    var totalAmount: String
    var layanan: String
    var nominal: String
    var feeAgen: Int
    var isRead: Bool
    var resi: String
    
    init(id: UUID = UUID(), id_notif: Int, date: String, feeBank: Int, totalAmount: String, layanan: String, nominal: String, feeAgen: Int, isRead: Bool, resi: String) {
        self.id = id
        self.id_notif = id_notif
        self.date = date
        self.feeBank = feeBank
        self.totalAmount = totalAmount
        self.layanan = layanan
        self.nominal = nominal
        self.feeAgen = feeAgen
        self.isRead = isRead
        self.resi = resi
    }
    
    init?(jsonDictionary: [String : Any]) {
        guard let id_notif = jsonDictionary["id_notif"] as? Int,
              let date = jsonDictionary["date"] as? String,
              let feeBank = jsonDictionary["feeBank"] as? Int,
              let totalAmount = jsonDictionary["totalAmount"] as? String,
              let layanan = jsonDictionary["layanan"] as? String,
              let nominal = jsonDictionary["nominal"] as? String,
              let feeAgen = jsonDictionary["feeAgen"] as? Int,
              let isRead = jsonDictionary["isRead"] as? Bool,
              let resi = jsonDictionary["resi"] as? String
        else {
            return nil
        }
        self.init(id_notif: id_notif, date: date, feeBank: feeBank, totalAmount: totalAmount, layanan: layanan, nominal: nominal, feeAgen: feeAgen, isRead: isRead, resi: resi)
    }
    

    static func == (lhs: Notifikasi, rhs: Notifikasi) -> Bool {
        return lhs.id_notif == rhs.id_notif
            && lhs.date == rhs.date
            && lhs.feeBank == rhs.feeBank
            && lhs.totalAmount == rhs.totalAmount
            && lhs.layanan == rhs.layanan
            && lhs.nominal == rhs.nominal
            && lhs.feeAgen == rhs.feeAgen
            && lhs.isRead == rhs.isRead
            && lhs.resi == rhs.resi
    }
    
}

//
//  RowNotification.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 07/02/24.
//

import Foundation
import SwiftUI

struct RowNotification: View {
    let notif : Notifikasi
    var body: some View {
        
        VStack(alignment: .center){
            HStack{
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(notif.isRead ? Color.clear : Color("colorDarkBlue"))
                Text(notif.layanan)
                    .bold()
                Spacer()
                Text(getRupiah(param: notif.totalAmount))
                    .foregroundColor(.gray)
            }
            HStack{
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.clear)
                Text(notif.date)
                    .foregroundColor(.gray)
                Spacer()
                Text("Resi.\(notif.resi)")
                    .foregroundColor(.gray)
            }
            Divider()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 60)
    }
}

struct RowNotification_Previews: PreviewProvider {
    static var previews: some View {
        RowNotification(notif: Notifikasi(id_notif: 0, date: "24-01-2023", feeBank: 0, totalAmount: "100000", layanan: "Transfer", nominal: "10000", feeAgen: 0, isRead: false, resi: "asdf"))
    }
}

//
//  RowLogTransaksi.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI

struct RowLogTransaksi: View {
    let mutasi : MutasiRekening
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(mutasi.nasabah.count > 25 ? mutasi.nasabah.prefix(25)+"..." : mutasi.nasabah)
                        .bold()
                    Spacer()
                    Text(mutasi.crTime)
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(getRupiah(param: mutasi.totalAmount))
                        .bold()
                    Spacer()
                    Text(mutasi.description)
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
            }
            .padding(.horizontal)
            Divider()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
    }
}

struct RowLogTransaksi_Previews: PreviewProvider {
    static var previews: some View {
        RowLogTransaksi(mutasi: MutasiRekening(id: 0, amount: 0, crTime: "asd", description: "asd", feeAgen: 0, feeBank: 0, idNotif: 0, nasabah: "Nasabah", resi: "asd", totalAmount: "D 500", totalAmountNReal: 0))
    }
}

func getRupiah(param: String) -> String {
    var modifiedParam = param  // Declare a variable to store the modified value

    let localeID = Locale(identifier: "in_ID")
    let formatRupiah = NumberFormatter()
    formatRupiah.locale = localeID
    formatRupiah.numberStyle = .currency
    
    var jenis = ""
    if param.contains("D") || param.contains("K") || param.contains("N") {
        let index = param.index(param.startIndex, offsetBy: 1)
        jenis = String(param[..<index])
        modifiedParam = param.replacingOccurrences(of: jenis + " ", with: "")
        jenis = "(" + jenis + ")"
    }
    
    if let intValue = Int(modifiedParam) {
        return jenis + " " + formatRupiah.string(from: NSNumber(value: intValue))!
    }
    
    return ""
}

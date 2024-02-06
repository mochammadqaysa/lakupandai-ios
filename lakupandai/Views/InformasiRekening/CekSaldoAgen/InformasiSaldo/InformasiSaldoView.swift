//
//  InformasiSaldoView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI

struct InformasiSaldoView: View {
    @Environment(\.presentationMode) var presentationMode
    let dataSaldo : [ItemValue]
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack {}
                        .frame(height: 20)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(radius: 3)
                        Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 20, verticalSpacing: 2) {
                            ForEach(dataSaldo) { item in
                                GridRow() {
                                    Text(item.header)
                                    Text(":")
                                    Text(item.value)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(nil)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Spacer()
                        Text("INFORMASI SALDO")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Text("Kembali")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.white)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                            presentationMode.wrappedValue.dismiss()
//                            pembelianVM.validateForm()
                        }
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct InformasiSaldoView_Previews: PreviewProvider {
    static var previews: some View {
        InformasiSaldoView(dataSaldo: [])
    }
}

//
//  InformasiSaldoNasabahVIew.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 03/01/24.
//

import SwiftUI

struct InformasiSaldoNasabahView: View {
    @Environment(\.presentationMode) var presentationMode
    let rmResult : String
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
                        VStack{
                            Text(rmResult)
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
                        Text("CEK SALDO NASABAH")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Text("Selesai")
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

struct InformasiSaldoNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        InformasiSaldoNasabahView(rmResult: "")
    }
}

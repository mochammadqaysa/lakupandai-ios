//
//  InformasiRekeningView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/11/23.
//

import SwiftUI

struct InformasiRekeningView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                List {
                    NavigationLink(destination: LazyView { CekSaldoAgenView() }) {
                        HStack(spacing:20) {
                            Image("ceksaldoagen")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Cek Saldo Agen")
                        }
                    }
                    NavigationLink(destination: LazyView { CekSaldoNasabahView() }){
                        HStack(spacing:20) {
                            Image("ceksaldonasabah")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Cek Saldo Nasabah")
                        }
                    }
                    NavigationLink(destination: LazyView { LogTransaksiView() }){
                        HStack(spacing:20) {
                            Image("mutasirekening")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Log Transaksi")
                        }
                    }
                    NavigationLink(destination: LazyView { CekStatusTerakhirView() }){
                        HStack(spacing:20) {
                            Image("cekstatusterakhir")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Cek Status Terakhir")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        Spacer()
                        Text("INFORMASI REKENING")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct InformasiRekeningView_Previews: PreviewProvider {
    static var previews: some View {
        InformasiRekeningView()
    }
}

struct LazyView<Content: View>: View {
    var content: () -> Content

    var body: some View {
        content()
    }
}

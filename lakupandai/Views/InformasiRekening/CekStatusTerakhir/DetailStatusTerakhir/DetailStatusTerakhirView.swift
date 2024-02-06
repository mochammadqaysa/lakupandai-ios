//
//  DetailStatusTerakhirView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 05/01/24.
//

import SwiftUI

struct DetailStatusTerakhirView: View {
    @Environment(\.presentationMode) var presentationMode
    let dataSaldo : [ItemValue]
    let layanan : String
    var body: some View {
        NavigationStack {
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack {}
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(radius: 3)
                        VStack {
                            HStack {
                                Image("logo_agen_bpd_diy")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                                .padding(.trailing)
                                Text(UserDefaultsManager.shared.getString(forKey: ConstantTransaction.USER_SESSION_AGENT_NAME) ?? "")
                                    .font(.title)
                                    .foregroundColor(Color("colorPrimary"))
                                    .fontWeight(.light)
                            }
                            .padding(.vertical)
                            Text(self.layanan)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 15) {
                                ForEach(self.dataSaldo) { item in
                                    GridRow() {
                                        Text(item.header)
                                        Text(":")
                                        Text(item.value)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .lineLimit(nil)
                                    }
                                }
                            }
                            Spacer()
                            Text("Informasi Lebih Lanjut, Silakan Hubungi\nBPD DIY Contact Center : 1500061\nSilakan Simpan Resi Ini\nSebagai Bukti Pembayaran Yang Sah")
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                        .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
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
                        Text("STATUS TERAKHIR")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Selesai")
                            .font(Font.footnote)
                            .bold()
                        .foregroundColor(.white)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
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

struct DetailStatusTerakhirView_Previews: PreviewProvider {
    static var previews: some View {
        DetailStatusTerakhirView(dataSaldo: [], layanan: "")
    }
}

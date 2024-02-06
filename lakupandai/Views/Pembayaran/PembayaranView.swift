//
//  PembayaranView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/11/23.
//

import SwiftUI
import AlertToast

struct PembayaranView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var pembayaranVM = PembayaranViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink(
                    destination: KonfirmasiPembayaranView(dataPembayaran: pembayaranVM.dataResponse, dataForm: pembayaranVM.dataForm, dataToken: pembayaranVM.dataToken, metodePembayaran: pembayaranVM.selectedMetodePembayaran),
                    isActive: $pembayaranVM.nextStep,
                    label: { EmptyView() }
                ).hidden()
                
                ZStack {
                    Image("bg")
                        .resizable()
                        .ignoresSafeArea()
                    Form {
                        Picker("Layanan", selection: $pembayaranVM.selectedLayanan) {
                            ForEach(pembayaranVM.listLayanan as? [String] ?? [], id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }
                        Picker("Sub Layanan", selection: $pembayaranVM.selectedSubLayanan) {
                            ForEach(pembayaranVM.selectedListSubLayanan, id: \.self) { item in
                                if let sub = item["productName"]! as? String {
                                    Text(sub).tag(sub)
                                }
                            }
                        }
                        HStack {
                            ZStack(alignment: .leading) {
                                Text(pembayaranVM.selectedLayanan == "SAMSAT" ? "Nomor Plat" : "ID Pembayaran / Pelanggan")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: pembayaranVM.idPembayaran.isEmpty)
                                    .offset(y: pembayaranVM.idPembayaran.isEmpty ? 0 : -20)
                                TextField("", text: $pembayaranVM.idPembayaran)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                            }
                            Image(systemName: "qrcode.viewfinder")
                        }
                        .padding(.top, pembayaranVM.idPembayaran.isEmpty ? 0 : 22)
                        if pembayaranVM.selectedLayanan == "PBB" {
                            ZStack(alignment: .leading) {
                                Text("Tahun Tagihan")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: pembayaranVM.tahunTagihan.isEmpty)
                                    .offset(y: pembayaranVM.tahunTagihan.isEmpty ? 0 : -20)
                                TextField("", text: $pembayaranVM.tahunTagihan)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .onChange(of: pembayaranVM.tahunTagihan){newValue in
                                        if newValue.count > 4 {
                                            pembayaranVM.tahunTagihan = String(newValue.prefix(4))
                                        }
                                    }
                            }
                            .padding(.top, pembayaranVM.tahunTagihan.isEmpty ? 0 : 22)
                        }
                        
                        if pembayaranVM.selectedSubLayanan == "BPJS Kesehatan" {
                            Picker("Jumlah Bulan", selection: $pembayaranVM.selectedJumlahBulan){
                                ForEach(["1","2","3","4","5","6","7","8","9","10","11","12"], id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                        Picker("Metode Pembayaran", selection: $pembayaranVM.selectedMetodePembayaran) {
                            ForEach(["Debit", "Tunai"], id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                        
                        if pembayaranVM.selectedMetodePembayaran == "Debit" {
                            ZStack(alignment: .leading) {
                                Text("Rekening Ponsel")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: pembayaranVM.rekeningPonsel.isEmpty)
                                    .offset(y: pembayaranVM.rekeningPonsel.isEmpty ? 0 : -20)
                                TextField("", text: $pembayaranVM.rekeningPonsel)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .onChange(of: pembayaranVM.rekeningPonsel){newValue in
                                        if newValue.count > 14 {
                                            pembayaranVM.rekeningPonsel = String(newValue.prefix(14))
                                        }
                                    }
                            }
                            .padding(.top, pembayaranVM.rekeningPonsel.isEmpty ? 0 : 22)
                        }
                    }
                    .scrollContentBackground(.hidden)

                }
                
            }
//            .blur(radius: pembayaranVM.isLoading ? 20 : 0)
            
            .toast(isPresenting: $pembayaranVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            
            .alert(isPresented: $pembayaranVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(pembayaranVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
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
                        Text("PEMBAYARAN")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                pembayaranVM.validateForm()
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

struct PembayaranView_Previews: PreviewProvider {
    static var previews: some View {
        PembayaranView()
    }
}

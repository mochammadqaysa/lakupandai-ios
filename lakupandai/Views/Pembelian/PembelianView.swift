//
//  PembelianView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/11/23.
//

import SwiftUI
import AlertToast

struct PembelianView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var pembelianVM = PembelianViewModel()
    var body: some View {
        NavigationStack{
            VStack {
                NavigationLink(
                    destination: KonfirmasiPembelianView(dataPembelian: pembelianVM.dataResponse, dataForm: pembelianVM.dataForm, dataToken: pembelianVM.dataToken, metodePembayaran: pembelianVM.selectedMetodePembayaran),
                    isActive: $pembelianVM.nextStep,
                    label: { EmptyView() }
                ).hidden()
                ZStack {
                    Image("bg")
                        .resizable()
                        .ignoresSafeArea()
                    
                    Form {
                        Picker("Layanan", selection: $pembelianVM.selectedLayanan) {
                            ForEach(pembelianVM.listLayanan as? [String] ?? [], id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }
                        Picker("Sub Layanan", selection: $pembelianVM.selectedSubLayanan) {
                            ForEach(pembelianVM.selectedListSubLayanan, id: \.self) { item in
                                if let sub = item["productName"]! as? String {
                                    Text(sub).tag(sub)
                                }
                            }
                        }
                        if pembelianVM.selectedLayanan.contains("PLN") {
                            ZStack(alignment: .leading) {
                                Text("No Pelanggan")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: pembelianVM.nomorPelanggan.isEmpty)
                                    .offset(y: pembelianVM.nomorPelanggan.isEmpty ? 0 : -20)
                                TextField("", text: $pembelianVM.nomorPelanggan)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                            }
                            .padding(.top, pembelianVM.nomorPelanggan.isEmpty ? 0 : 22)
                        }
                        
                        if pembelianVM.selectedLayanan.contains("Telepon") {
                            ZStack(alignment: .leading) {
                                Text("Nomor Ponsel")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: pembelianVM.nomorPonsel.isEmpty)
                                    .offset(y: pembelianVM.nomorPonsel.isEmpty ? 0 : -20)
                                TextField("", text: $pembelianVM.nomorPonsel)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                            }
                            .padding(.top, pembelianVM.nomorPonsel.isEmpty ? 0 : 22)
                        }
                        
                        Picker("Nominal", selection: $pembelianVM.selectedNominal){
                            ForEach(pembelianVM.listDenom, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Metode Pembayaran", selection: $pembelianVM.selectedMetodePembayaran) {
                            ForEach(["Debit", "Tunai"], id: \.self) {
                                Text($0)
                            }
                        }
                        if pembelianVM.selectedMetodePembayaran == "Debit" {
                            ZStack(alignment: .leading) {
                                Text("Rekening Ponsel")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: pembelianVM.rekeningPonsel.isEmpty)
                                    .offset(y: pembelianVM.rekeningPonsel.isEmpty ? 0 : -20)
                                TextField("", text: $pembelianVM.rekeningPonsel)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .onChange(of: pembelianVM.rekeningPonsel){newValue in
                                        if newValue.count > 14 {
                                            pembelianVM.rekeningPonsel = String(newValue.prefix(14))
                                        }
                                    }
                            }
                            .padding(.top, pembelianVM.rekeningPonsel.isEmpty ? 0 : 22)
                        }
                        
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .toast(isPresenting: $pembelianVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            
            .alert(isPresented: $pembelianVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(pembelianVM.alertMessage),
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
                        Text("PEMBELIAN")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                        .foregroundColor(.white)
                        .onTapGesture {
                            pembelianVM.validateForm()
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

struct PembelianView_Previews: PreviewProvider {
    static var previews: some View {
        PembelianView()
    }
}

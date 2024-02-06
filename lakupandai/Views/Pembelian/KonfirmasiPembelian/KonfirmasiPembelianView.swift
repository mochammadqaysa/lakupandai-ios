//
//  KonfirmasiPembelianView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 22/12/23.
//

import SwiftUI
import AlertToast

struct KonfirmasiPembelianView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var konfirmasiPembelianVM = KonfirmasiPembelianViewModel()
    let dataPembelian : [ItemValue]
    let dataForm : [String : Any]
    let dataToken : String
    let metodePembayaran : String
    @State private var navigateBack = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: HasilPembelianView(dataKonfirmasi: konfirmasiPembelianVM.dataKonfirmasi, layanan: konfirmasiPembelianVM.dataLayanan, onDismiss: { data in
                            navigateBack = data
                        },navigateBack: $navigateBack),
                        isActive: $konfirmasiPembelianVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    VStack{
                        Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 15) {
                            ForEach(dataPembelian) { item in
                                GridRow() {
                                    Text(item.header)
                                    Text(":")
                                    Text(item.value)
                                }
                            }
                        }
                        .padding(.bottom,60)
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                        VStack{
                            Text("Metode Pembelian")
                            Text(metodePembayaran)
                        }
                        .foregroundColor(.gray)
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                        
                        if metodePembayaran == "Debit" {
                            VStack(alignment: .center){
                                ZStack(alignment: .center) {
                                    if konfirmasiPembelianVM.otpNasabah.isEmpty {
                                        Text("Masukan kode OTP Nasabah")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiPembelianVM.otpNasabah)
                                        .keyboardType(.numberPad)
                                        .foregroundColor(.black)
                                        .onChange(of: konfirmasiPembelianVM.otpNasabah){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiPembelianVM.otpNasabah = String(newValue.prefix(6))
                                            }
                                        }
                                }
                                .padding(15)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                            .background(.white)
                            .padding(.top,20)
                        }
                        
                        VStack(alignment: .center){
                            ZStack(alignment: .center) {
                                if konfirmasiPembelianVM.pinAgen.isEmpty {
                                    Text("Masukan PIN Agen")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .italic()
                                }
                                SecureField("", text: $konfirmasiPembelianVM.pinAgen)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .onChange(of: konfirmasiPembelianVM.pinAgen){newValue in
                                        if newValue.count > 6 {
                                            konfirmasiPembelianVM.pinAgen = String(newValue.prefix(6))
                                        }
                                    }
                            }
                            .padding(15)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                        .background(.white)
                        .padding(.top,20)
                        
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    .padding(.top,35)
                }
            }
            .onAppear {
                if navigateBack {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .toast(isPresenting: $konfirmasiPembelianVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $konfirmasiPembelianVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiPembelianVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
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
                        Text("KONFIRMASI PEMBELIAN")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                konfirmasiPembelianVM.validateForm(metodePembayaran: self.metodePembayaran, dataPembayaran: self.dataPembelian, dataForm: self.dataForm, dataToken: self.dataToken)
//                                konfirmasiPembelianVM.validateForm(metodePembayaran: self.metodePembayaran, dataPembayaran: self.dataPembayaran, dataForm: self.dataForm, dataToken: self.dataToken)
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

struct KonfirmasiPembelianView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiPembelianView(dataPembelian: [], dataForm: [:], dataToken: "", metodePembayaran: "")
    }
}

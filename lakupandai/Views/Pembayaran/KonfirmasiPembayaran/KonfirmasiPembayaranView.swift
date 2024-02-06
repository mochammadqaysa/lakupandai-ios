//
//  KonfirmasiPembayaranView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/12/23.
//

import SwiftUI
import AlertToast

struct KonfirmasiPembayaranView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var konfirmasiPembayaranVM = KonfirmasiPembayaranViewModel()
    let dataPembayaran : [ItemValue]
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
                        destination: HasilPembayaranView(dataKonfirmasi: konfirmasiPembayaranVM.dataKonfirmasi, layanan: konfirmasiPembayaranVM.dataLayanan, onDismiss: { data in
                            navigateBack = data
                        },navigateBack: $navigateBack),
                        isActive: $konfirmasiPembayaranVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    VStack{
                        Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 15) {
                            ForEach(dataPembayaran) { item in
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
                            Text("Metode Pembayaran")
                            Text(metodePembayaran)
                        }
                        .foregroundColor(.gray)
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                        
                        if metodePembayaran == "Debit" {
                            VStack(alignment: .center){
                                ZStack(alignment: .center) {
                                    if konfirmasiPembayaranVM.otpNasabah.isEmpty {
                                        Text("Masukan kode OTP Nasabah")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiPembayaranVM.otpNasabah)
                                        .keyboardType(.numberPad)
                                        .foregroundColor(.black)
                                        .onChange(of: konfirmasiPembayaranVM.otpNasabah){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiPembayaranVM.otpNasabah = String(newValue.prefix(6))
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
                                if konfirmasiPembayaranVM.pinAgen.isEmpty {
                                    Text("Masukan PIN Agen")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .italic()
                                }
                                SecureField("", text: $konfirmasiPembayaranVM.pinAgen)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .onChange(of: konfirmasiPembayaranVM.pinAgen){newValue in
                                        if newValue.count > 6 {
                                            konfirmasiPembayaranVM.pinAgen = String(newValue.prefix(6))
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
            .toast(isPresenting: $konfirmasiPembayaranVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $konfirmasiPembayaranVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiPembayaranVM.alertMessage),
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
                        Text("KONFIRMASI PEMBAYARAN")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                konfirmasiPembayaranVM.validateForm(metodePembayaran: self.metodePembayaran, dataPembayaran: self.dataPembayaran, dataForm: self.dataForm, dataToken: self.dataToken)
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

struct KonfirmasiPembayaranView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiPembayaranView(dataPembayaran: [], dataForm: [:], dataToken: "", metodePembayaran: "")
    }
}

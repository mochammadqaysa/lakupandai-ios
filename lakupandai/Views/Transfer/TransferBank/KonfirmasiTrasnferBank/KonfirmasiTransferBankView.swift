//
//  KonfirmasiTransferBankView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct KonfirmasiTransferBankView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var konfirmasiTransferBankVM = KonfirmasiTransferBankViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        NavigationLink(
                            destination: KonfirmasiTransferBankDetailView(dataTransferDari: konfirmasiTransferBankVM.dataTransferDari, dataTransferKe: konfirmasiTransferBankVM.dataTransferKe, tokenNasabah: konfirmasiTransferBankVM.token, layanan: konfirmasiTransferBankVM.dataLayanan),
                            isActive: $konfirmasiTransferBankVM.nextStep,
                            label: { EmptyView() }
                        ).hidden()
                    }
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.gray.opacity(0.2))
                            .shadow(radius: 3)
                        VStack {
                            Text("KONFIRMASI TRANSFER")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Spacer()
                            Text("Masukan Kode OTP(One Time Password) yang dikirimkan kepada Nasabah melalui SMS")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                            VStack(alignment: .center){
                                ZStack(alignment: .center) {
                                    if konfirmasiTransferBankVM.token.isEmpty {
                                        Text("Masukan OTP Nasabah")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiTransferBankVM.token)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: konfirmasiTransferBankVM.token){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiTransferBankVM.token = String(newValue.prefix(6))
                                            }
                                        }
                                }
                                .padding(15)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                            .background(.white)
                            .padding(.top,20)
                            .padding(.bottom)
                            
                            Text("Masukan 6 Digit Angka Yang Dikirimkan Melalui SMS")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        if konfirmasiTransferBankVM.detikRequestOtp < 1 {
                            Button("Kirim ulang OTP") {
                                konfirmasiTransferBankVM.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    konfirmasiTransferBankVM.requestOtp()
                                    defer {
                                        konfirmasiTransferBankVM.isLoading = false
                                    }
                                }
                            }
                            .font(.footnote)
                        } else {
                            Text("Tunggu ").font(.footnote)
                                .foregroundColor(.gray) + Text("\(konfirmasiTransferBankVM.detikRequestOtp)").font(.footnote).bold()
                                .foregroundColor(.gray) + Text(" detik untuk mengirim ulang OTP")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    .onReceive(konfirmasiTransferBankVM.timer) { _ in
                        if konfirmasiTransferBankVM.detikRequestOtp > 0 {
                            konfirmasiTransferBankVM.detikRequestOtp -= 1
                        }
                    }
                }
            }
            .toast(isPresenting: $konfirmasiTransferBankVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert("Peringatan", isPresented: $konfirmasiTransferBankVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(konfirmasiTransferBankVM.alertMessage)
            }
            .alert(isPresented: $konfirmasiTransferBankVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiTransferBankVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarBackButtonHidden(true)
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
                        Image("ic_logo_diy_white")
                            .resizable()
                            .frame(width: 150, height: 35)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                konfirmasiTransferBankVM.validateForm()
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

struct KonfirmasiTransferBankView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiTransferBankView()
    }
}

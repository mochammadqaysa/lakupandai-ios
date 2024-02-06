//
//  KonfirmasiTransferBPDView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct KonfirmasiTransferBPDView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var konfirmasiTransferBPDVM = KonfirmasiTransferBPDViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        NavigationLink(
                            destination: KonfirmasiTransferBPDDetailView(dataTransferDari: konfirmasiTransferBPDVM.dataTransferDari, dataTransferKe: konfirmasiTransferBPDVM.dataTransferKe, tokenNasabah: konfirmasiTransferBPDVM.otpNasabah, layanan: konfirmasiTransferBPDVM.dataLayanan),
                            isActive: $konfirmasiTransferBPDVM.nextStep,
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
                                    if konfirmasiTransferBPDVM.otpNasabah.isEmpty {
                                        Text("Masukan OTP Nasabah")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiTransferBPDVM.otpNasabah)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: konfirmasiTransferBPDVM.otpNasabah){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiTransferBPDVM.otpNasabah = String(newValue.prefix(6))
                                            }
                                        }
                                }
                                .padding(15)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                            .background(.white)
                            .padding(.top,20)
                        }
                        .padding()
                        
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        if konfirmasiTransferBPDVM.detikRequestOtp < 1 {
                            Button("Kirim ulang OTP") {
                                konfirmasiTransferBPDVM.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    konfirmasiTransferBPDVM.requestOtp()
                                    defer {
                                        konfirmasiTransferBPDVM.isLoading = false
                                    }
                                }
                            }
                            .font(.footnote)
                        } else {
                            Text("Tunggu ").font(.footnote)
                                .foregroundColor(.gray) + Text("\(konfirmasiTransferBPDVM.detikRequestOtp)").font(.footnote).bold()
                                .foregroundColor(.gray) + Text(" detik untuk mengirim ulang OTP")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    .onReceive(konfirmasiTransferBPDVM.timer) { _ in
                        if konfirmasiTransferBPDVM.detikRequestOtp > 0 {
                            konfirmasiTransferBPDVM.detikRequestOtp -= 1
                        }
                    }
                }
            }
            .toast(isPresenting: $konfirmasiTransferBPDVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert("Peringatan", isPresented: $konfirmasiTransferBPDVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(konfirmasiTransferBPDVM.alertMessage)
            }
            .alert(isPresented: $konfirmasiTransferBPDVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiTransferBPDVM.alertMessage),
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
                                konfirmasiTransferBPDVM.validateForm()
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

struct KonfirmasiTransferBPDView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiTransferBPDView()
    }
}

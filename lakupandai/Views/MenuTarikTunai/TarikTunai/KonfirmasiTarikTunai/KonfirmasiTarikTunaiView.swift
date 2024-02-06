//
//  KonfirmasiTarikTunaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct KonfirmasiTarikTunaiView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var konfirmasiTarikTunaiVM = KonfirmasiTarikTunaiViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        NavigationLink(
                            destination: KonfirmasiTarikTunaiDetailView(dataTarik: konfirmasiTarikTunaiVM.dataTarikTunai, tokenNasabah: konfirmasiTarikTunaiVM.otpNasabah),
                            isActive: $konfirmasiTarikTunaiVM.nextStep,
                            label: { EmptyView() }
                        ).hidden()
                    }
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.gray.opacity(0.2))
                            .shadow(radius: 3)
                        VStack {
                            Text("KONFIRMASI TARIK TUNAI")
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
                                    if konfirmasiTarikTunaiVM.otpNasabah.isEmpty {
                                        Text("Masukan OTP Nasabah")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiTarikTunaiVM.otpNasabah)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: konfirmasiTarikTunaiVM.otpNasabah){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiTarikTunaiVM.otpNasabah = String(newValue.prefix(6))
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
                        if konfirmasiTarikTunaiVM.detikRequestOtp < 1 {
                            Button("Kirim ulang OTP") {
                                konfirmasiTarikTunaiVM.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    konfirmasiTarikTunaiVM.requestOtp()
                                    defer {
                                        konfirmasiTarikTunaiVM.isLoading = false
                                    }
                                }
                            }
                            .font(.footnote)
                        } else {
                            Text("Tunggu ").font(.footnote)
                                .foregroundColor(.gray) + Text("\(konfirmasiTarikTunaiVM.detikRequestOtp)").font(.footnote).bold()
                                .foregroundColor(.gray) + Text(" detik untuk mengirim ulang OTP")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    .onReceive(konfirmasiTarikTunaiVM.timer) { _ in
                        if konfirmasiTarikTunaiVM.detikRequestOtp > 0 {
                            konfirmasiTarikTunaiVM.detikRequestOtp -= 1
                        }
                    }
                }
            }
            .toast(isPresenting: $konfirmasiTarikTunaiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $konfirmasiTarikTunaiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiTarikTunaiVM.alertMessage),
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
                        Text("KONFIRMASI TARIK TUNAI")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                konfirmasiTarikTunaiVM.validateForm()
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

struct KonfirmasiTarikTunaiView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiTarikTunaiView()
    }
}

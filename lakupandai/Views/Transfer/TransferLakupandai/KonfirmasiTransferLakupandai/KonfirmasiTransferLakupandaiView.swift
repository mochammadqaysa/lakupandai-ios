//
//  KonfirmasiTransferLakupandaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct KonfirmasiTransferLakupandaiView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var konfirmasiTransferLakupandaiVM = KonfirmasiTransferLakupandaiViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        NavigationLink(
                            destination: KonfirmasiTransferLakupandaiDetailView(dataTransferDari: konfirmasiTransferLakupandaiVM.dataTransferDari, dataTransferKe: konfirmasiTransferLakupandaiVM.dataTransferKe, tokenNasabah: konfirmasiTransferLakupandaiVM.token, layanan: konfirmasiTransferLakupandaiVM.dataLayanan),
                            isActive: $konfirmasiTransferLakupandaiVM.nextStep,
                            label: { EmptyView() }
                        ).hidden()
                    }
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.gray.opacity(0.2))
                            .shadow(radius: 3)
                        VStack {
                            Text("INPUT TOKEN")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            VStack(alignment: .center){
                                ZStack(alignment: .center) {
                                    if konfirmasiTransferLakupandaiVM.token.isEmpty {
                                        Text("Token")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiTransferLakupandaiVM.token)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: konfirmasiTransferLakupandaiVM.token){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiTransferLakupandaiVM.token = String(newValue.prefix(6))
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
                        if konfirmasiTransferLakupandaiVM.detikRequestOtp < 1 {
                            Button("Kirim ulang OTP") {
                                konfirmasiTransferLakupandaiVM.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    konfirmasiTransferLakupandaiVM.requestOtp()
                                    defer {
                                        konfirmasiTransferLakupandaiVM.isLoading = false
                                    }
                                }
                            }
                            .font(.footnote)
                        } else {
                            Text("Tunggu ").font(.footnote)
                                .foregroundColor(.gray) + Text("\(konfirmasiTransferLakupandaiVM.detikRequestOtp)").font(.footnote).bold()
                                .foregroundColor(.gray) + Text(" detik untuk mengirim ulang OTP")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    .onReceive(konfirmasiTransferLakupandaiVM.timer) { _ in
                        if konfirmasiTransferLakupandaiVM.detikRequestOtp > 0 {
                            konfirmasiTransferLakupandaiVM.detikRequestOtp -= 1
                        }
                    }
                }
            }
            .toast(isPresenting: $konfirmasiTransferLakupandaiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert("Peringatan", isPresented: $konfirmasiTransferLakupandaiVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(konfirmasiTransferLakupandaiVM.alertMessage)
            }
            .alert(isPresented: $konfirmasiTransferLakupandaiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiTransferLakupandaiVM.alertMessage),
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
                                konfirmasiTransferLakupandaiVM.validateForm()
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

struct KonfirmasiTransferLakupandaiView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiTransferLakupandaiView()
    }
}

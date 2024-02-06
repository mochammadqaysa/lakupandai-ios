//
//  ResponseAktivasiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/02/24.
//

import SwiftUI
import AlertToast

struct ResponseAktivasiView: View {
    let dataAktivasi : [ItemValue]
    @Environment(\.presentationMode) var presentationMode
    @StateObject var responseAktivasiVM = ResponseAktivasiViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        
                    }
                    .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(radius: 3)
                        VStack (alignment: .leading) {
                            Grid(alignment: .leading,horizontalSpacing: 30, verticalSpacing: 5) {
                                ForEach(dataAktivasi) { item in
                                    Text(item.header)
                                        .font(.title3)
                                        .bold()
                                    Text(item.value)
                                        .font(Font.callout)
                                        .padding(.bottom)
                                }
                            }
                            .padding(.vertical)
                            .padding(.horizontal)
                            VStack(alignment: .center){
                                ZStack(alignment: .center) {
                                    if responseAktivasiVM.otpNasabah.isEmpty {
                                        Text("Masukan OTP Nasabah")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $responseAktivasiVM.otpNasabah)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: responseAktivasiVM.otpNasabah){newValue in
                                            if newValue.count > 6 {
                                                responseAktivasiVM.otpNasabah = String(newValue.prefix(6))
                                            }
                                        }
                                }
                                .padding(15)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 8).foregroundColor(Color.white))
                                .background(.gray.opacity(0.5))
                                
                                ZStack(alignment: .center) {
                                    if responseAktivasiVM.pinAgen.isEmpty {
                                        Text("Masukan PIN Agen")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $responseAktivasiVM.pinAgen)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: responseAktivasiVM.pinAgen){newValue in
                                            if newValue.count > 6 {
                                                responseAktivasiVM.pinAgen = String(newValue.prefix(6))
                                            }
                                        }
                                }
                                .padding(15)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 8).foregroundColor(Color.white))
                                .background(.gray.opacity(0.5))
                                
                            }
                            
                        }
                        .padding()
                        
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        if responseAktivasiVM.detikRequestOtp < 1 {
                            Button("Kirim ulang OTP") {
                                responseAktivasiVM.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    responseAktivasiVM.requestOtp()
                                    defer {
                                        responseAktivasiVM.isLoading = false
                                    }
                                }
                            }
                            .font(.footnote)
                        } else {
                            Text("Tunggu ").font(.footnote)
                                .foregroundColor(.gray) + Text("\(responseAktivasiVM.detikRequestOtp)").font(.footnote).bold()
                                .foregroundColor(.gray) + Text(" detik untuk mengirim ulang OTP")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    .onReceive(responseAktivasiVM.timer) { _ in
                        if responseAktivasiVM.detikRequestOtp > 0 {
                            responseAktivasiVM.detikRequestOtp -= 1
                        }
                    }
                }
            }
            .alert(isPresented: $responseAktivasiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(responseAktivasiVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert("Peringatan", isPresented: $responseAktivasiVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(responseAktivasiVM.alertMessage)
            }
            .alert(isPresented: $responseAktivasiVM.showToastResponse) {
                Alert(
                    title: Text("INFORMASI"),
                    message: Text(responseAktivasiVM.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .alert("INFORMASI", isPresented: $responseAktivasiVM.showToastResponse) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text(responseAktivasiVM.alertMessage)
            }
            .toast(isPresenting: $responseAktivasiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        Spacer()
                        Text("KONFIRMASI AKTIVASI REKENING BARU")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                responseAktivasiVM.validateForm()
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

struct ResponseAktivasiView_Previews: PreviewProvider {
    static var previews: some View {
        ResponseAktivasiView(dataAktivasi: [ItemValue(header: "Nama", value: "Jarjit"), ItemValue(header: "Alamat", value: "Disini")])
    }
}

//
//  TarikTunaiTanpaKartuView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct TarikTunaiTanpaKartuView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var tarikTunaiTanpaKartuVM = TarikTunaiTanpaKartuViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: HasilTarikTunaiTanpaKartuView(dataHasil: tarikTunaiTanpaKartuVM.dataTarikTunai, layanan: "Penarikan Dana-Tanpa Kartu"),
                        isActive: $tarikTunaiTanpaKartuVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    Form {
                        ZStack(alignment: .leading) {
                            Text("Kode Reservasi")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: tarikTunaiTanpaKartuVM.kodeReservasi.isEmpty)
                                .offset(y: tarikTunaiTanpaKartuVM.kodeReservasi.isEmpty ? 0 : -20)
                            TextField("", text: $tarikTunaiTanpaKartuVM.kodeReservasi)
                            .keyboardType(.numberPad)
                            .onChange(of: tarikTunaiTanpaKartuVM.kodeReservasi){newValue in
                                if newValue.count > 20 {
                                    tarikTunaiTanpaKartuVM.kodeReservasi = String(newValue.prefix(20))
                                }
                            }
                        }
                        .padding(.top, tarikTunaiTanpaKartuVM.kodeReservasi.isEmpty ? 0 : 22)
                        
                        ZStack(alignment: .leading) {
                            Text("OTP")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: tarikTunaiTanpaKartuVM.otpNasabah.isEmpty)
                                .offset(y: tarikTunaiTanpaKartuVM.otpNasabah.isEmpty ? 0 : -20)
                            TextField("", text: $tarikTunaiTanpaKartuVM.otpNasabah)
                                .keyboardType(.numberPad)
                                .onChange(of: tarikTunaiTanpaKartuVM.otpNasabah){newValue in
                                    if newValue.count > 6 {
                                        tarikTunaiTanpaKartuVM.otpNasabah = String(newValue.prefix(6))
                                    }
                                }
                        }
                        .padding(.top, tarikTunaiTanpaKartuVM.otpNasabah.isEmpty ? 0 : 22)
                        
                        ZStack(alignment: .leading) {
                            Text("PIN Agen")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: tarikTunaiTanpaKartuVM.pinAgen.isEmpty)
                                .offset(y: tarikTunaiTanpaKartuVM.pinAgen.isEmpty ? 0 : -20)
                            SecureField("", text: $tarikTunaiTanpaKartuVM.pinAgen)
                                .keyboardType(.numberPad)
                                .onChange(of: tarikTunaiTanpaKartuVM.pinAgen){newValue in
                                    if newValue.count > 6 {
                                        tarikTunaiTanpaKartuVM.pinAgen = String(newValue.prefix(6))
                                    }
                                }
                        }
                        .padding(.top, tarikTunaiTanpaKartuVM.pinAgen.isEmpty ? 0 : 22)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            
            .toast(isPresenting: $tarikTunaiTanpaKartuVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $tarikTunaiTanpaKartuVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(tarikTunaiTanpaKartuVM.alertMessage),
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
                        Text("REQUEST TARIK TUNAI")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                tarikTunaiTanpaKartuVM.validateForm()
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

struct TarikTunaiTanpaKartuView_Previews: PreviewProvider {
    static var previews: some View {
        TarikTunaiTanpaKartuView()
    }
}

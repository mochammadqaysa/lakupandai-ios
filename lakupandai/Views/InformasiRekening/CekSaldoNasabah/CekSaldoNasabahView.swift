//
//  CekSaldoNasabahView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI
import AlertToast

struct CekSaldoNasabahView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cekSaldoNasabahVM = CekSaldoNasabahViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: InformasiSaldoNasabahView(rmResult: cekSaldoNasabahVM.rmResponse),
                        isActive: $cekSaldoNasabahVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    
                    Form {
                        ZStack(alignment: .leading) {
                            Text("No HP Nasabah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: cekSaldoNasabahVM.noTelpon.isEmpty)
                                .offset(y: cekSaldoNasabahVM.noTelpon.isEmpty ? 0 : -20)
                            TextField("", text: $cekSaldoNasabahVM.noTelpon)
                                .keyboardType(.phonePad)
                                .onChange(of: cekSaldoNasabahVM.noTelpon){newValue in
                                    if newValue.count > 13 {
                                        cekSaldoNasabahVM.noTelpon = String(newValue.prefix(13))
                                    }
                                }
                        }
                        .padding(.top, cekSaldoNasabahVM.noTelpon.isEmpty ? 0 : 22)
                        ZStack(alignment: .leading) {
                            Text("PIN")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: cekSaldoNasabahVM.pinAgen.isEmpty)
                                .offset(y: cekSaldoNasabahVM.pinAgen.isEmpty ? 0 : -20)
                            SecureField("", text: $cekSaldoNasabahVM.pinAgen)
                                .keyboardType(.numberPad)
                                .onChange(of: cekSaldoNasabahVM.pinAgen){newValue in
                                    if newValue.count > 6 {
                                        cekSaldoNasabahVM.pinAgen = String(newValue.prefix(6))
                                    }
                                }
                        }
                        .padding(.top, cekSaldoNasabahVM.pinAgen.isEmpty ? 0 : 22)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            
            .toast(isPresenting: $cekSaldoNasabahVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $cekSaldoNasabahVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(cekSaldoNasabahVM.alertMessage),
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
                        Text("CEK SALDO NASABAH")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                        .foregroundColor(.white)
                        .onTapGesture {
                            cekSaldoNasabahVM.validateForm()
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

struct CekSaldoNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        CekSaldoNasabahView()
    }
}

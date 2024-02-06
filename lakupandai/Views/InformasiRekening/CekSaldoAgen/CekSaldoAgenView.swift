//
//  CekSaldoAgenView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI
import AlertToast

struct CekSaldoAgenView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cekSaldoAgenVM = CekSaldoAgenViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    NavigationLink(
                        destination: InformasiSaldoView(dataSaldo: cekSaldoAgenVM.dataSaldo),
                        isActive: $cekSaldoAgenVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    Text("Verifikasi PIN Agen")
                        .foregroundColor(.gray)
                    PasscodeField(pin: $cekSaldoAgenVM.pinAgen)
//                    OTPTextField()
//                    OTPTextField(numberOfFields: 6)
                    Spacer()
                }
            }
            .toast(isPresenting: $cekSaldoAgenVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $cekSaldoAgenVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(cekSaldoAgenVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Button(action: {
                            cekSaldoAgenVM.pinAgen = ""
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        Spacer()
                        Text("CEK SALDO AGEN")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                        .foregroundColor(.white)
                        .onTapGesture {
                            cekSaldoAgenVM.validatePin()
//                            pembelianVM.validateForm()
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

struct CekSaldoAgenView_Previews: PreviewProvider {
    static var previews: some View {
        CekSaldoAgenView()
    }
}

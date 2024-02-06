//
//  RequestTransferBankView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct RequestTransferBankView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var requestTransferBankVM = RequestTransferBankViewModel()
    @State private var navigateBack = false
    var body: some View {
        NavigationStack {
            ZStack {
                
                    Image("bg")
                        .resizable()
                        .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: KonfirmasiRequestTransferBankView(dataTransferDari: requestTransferBankVM.dataTransferDari, dataTransferKe: requestTransferBankVM.dataTransferKe, tokenNasabah: requestTransferBankVM.dataToken,onDismiss: { data in
                            navigateBack = data
                        },navigateBack: $navigateBack),
                        isActive: $requestTransferBankVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    Form {
                        Picker("Sumber", selection: $requestTransferBankVM.selectedSumber) {
                            ForEach(["Nasabah"], id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }
                        ZStack(alignment: .leading) {
                            Text("Nomor HP Nasabah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferBankVM.noHPNasabah.isEmpty)
                                .offset(y: requestTransferBankVM.noHPNasabah.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferBankVM.noHPNasabah)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .onChange(of: requestTransferBankVM.noHPNasabah) { newValue in
                                    if newValue.count > 13 {
                                        requestTransferBankVM.noHPNasabah = String(newValue.prefix(13))
                                    }
                                }
                        }
                        .padding(.top, requestTransferBankVM.noHPNasabah.isEmpty ? 0 : 22)
                        Picker("Rekening Tujuan", selection: $requestTransferBankVM.selectedRekeningTujuan){
                            ForEach(requestTransferBankVM.listRekeningTujuan, id: \.self) { item in
                                Text(item.bankName).tag(item.bankName)
                            }
                        }
                        
                        ZStack(alignment: .leading) {
                            Text("No Rekening Tujuan")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferBankVM.noRekeningTujuan.isEmpty)
                                .offset(y: requestTransferBankVM.noRekeningTujuan.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferBankVM.noRekeningTujuan)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, requestTransferBankVM.noRekeningTujuan.isEmpty ? 0 : 22)
                        
                        ZStack(alignment: .leading) {
                            Text("Jumlah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferBankVM.jumlah.isEmpty)
                                .offset(y: requestTransferBankVM.jumlah.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferBankVM.jumlah)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, requestTransferBankVM.jumlah.isEmpty ? 0 : 22)
                        
                        
                    }
                        .scrollContentBackground(.hidden)
                }
            }
            .onAppear {
                if navigateBack {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .toast(isPresenting: $requestTransferBankVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert("Peringatan", isPresented: $requestTransferBankVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(requestTransferBankVM.alertMessage)
            }
            .alert(isPresented: $requestTransferBankVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(requestTransferBankVM.alertMessage),
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
                        Text("TRANSFER ANTAR BANK")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                requestTransferBankVM.validateForm()
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

struct RequestTransferBankView_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransferBankView()
    }
}

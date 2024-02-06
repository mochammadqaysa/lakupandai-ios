//
//  RequestTransferBPDView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct RequestTransferBPDView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var requestTransferBPDVM = RequestTransferBPDViewModel()
    @State private var navigateBack = false
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: KonfirmasiRequestTransferBPDView( dataTransferDari: requestTransferBPDVM.dataTransferDari, dataTransferKe: requestTransferBPDVM.dataTransferKe, tokenNasabah: requestTransferBPDVM.dataToken,onDismiss: { data in
                            navigateBack = data
                        },navigateBack: $navigateBack),
                        isActive: $requestTransferBPDVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    Form {
                        ZStack(alignment: .leading) {
                            Text("Nomor HP Nasabah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferBPDVM.noHPNasabah.isEmpty)
                                .offset(y: requestTransferBPDVM.noHPNasabah.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferBPDVM.noHPNasabah)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .onChange(of: requestTransferBPDVM.noHPNasabah) {newValue in
                                    if newValue.count > 13 {
                                        requestTransferBPDVM.noHPNasabah = String(newValue.prefix(13))
                                    }
                                    
                                }
                        }
                        .padding(.top, requestTransferBPDVM.noHPNasabah.isEmpty ? 0 : 22)
                        
                        
                        ZStack(alignment: .leading) {
                            Text("No Rekening")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferBPDVM.noRekening.isEmpty)
                                .offset(y: requestTransferBPDVM.noRekening.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferBPDVM.noRekening)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .onChange(of: requestTransferBPDVM.noRekening) {newValue in
                                    if newValue.count > 15 {
                                        requestTransferBPDVM.noRekening = String(newValue.prefix(15))
                                    }
                                    
                                }
                        }
                        .padding(.top, requestTransferBPDVM.noRekening.isEmpty ? 0 : 22)
                        
                        ZStack(alignment: .leading) {
                            Text("Nominal")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferBPDVM.nominal.isEmpty)
                                .offset(y: requestTransferBPDVM.nominal.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferBPDVM.nominal)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, requestTransferBPDVM.nominal.isEmpty ? 0 : 22)
                        
                        
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .onAppear {
                if navigateBack {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .toast(isPresenting: $requestTransferBPDVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert("Peringatan", isPresented: $requestTransferBPDVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(requestTransferBPDVM.alertMessage)
            }
            .alert(isPresented: $requestTransferBPDVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(requestTransferBPDVM.alertMessage),
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
                        Text("TRANSFER")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                requestTransferBPDVM.validateForm()
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

struct RequestTransferBPDView_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransferBPDView()
    }
}

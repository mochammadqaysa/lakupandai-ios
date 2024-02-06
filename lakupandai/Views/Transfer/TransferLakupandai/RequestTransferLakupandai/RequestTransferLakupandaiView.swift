//
//  RequestTransferLakupandaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct RequestTransferLakupandaiView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var requestTransferLakupandaiVM = RequestTransferLakupandaiViewModel()
    @State private var navigateBack = false
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: KonfirmasiRequestTransferLakupandaiView(dataTransferDari: requestTransferLakupandaiVM.dataTransferDari, dataTransferKe: requestTransferLakupandaiVM.dataTransferKe, tokenNasabah: requestTransferLakupandaiVM.dataToken,onDismiss: { data in
                            navigateBack = data
                        },navigateBack: $navigateBack),
                        isActive: $requestTransferLakupandaiVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    
                    Form {
                        ZStack(alignment: .leading) {
                            Text("Nomor HP Nasabah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferLakupandaiVM.noHPNasabah.isEmpty)
                                .offset(y: requestTransferLakupandaiVM.noHPNasabah.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferLakupandaiVM.noHPNasabah)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, requestTransferLakupandaiVM.noHPNasabah.isEmpty ? 0 : 22)
                        
                        
                        ZStack(alignment: .leading) {
                            Text("Nomor HP Tujuan")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferLakupandaiVM.noHPTujuan.isEmpty)
                                .offset(y: requestTransferLakupandaiVM.noHPTujuan.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferLakupandaiVM.noHPTujuan)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, requestTransferLakupandaiVM.noHPTujuan.isEmpty ? 0 : 22)
                        
                        ZStack(alignment: .leading) {
                            Text("Nominal")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: requestTransferLakupandaiVM.nominal.isEmpty)
                                .offset(y: requestTransferLakupandaiVM.nominal.isEmpty ? 0 : -20)
                            TextField("", text: $requestTransferLakupandaiVM.nominal)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, requestTransferLakupandaiVM.nominal.isEmpty ? 0 : 22)
                        
                        
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            
            .onAppear {
                if navigateBack {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .toast(isPresenting: $requestTransferLakupandaiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert("Peringatan", isPresented: $requestTransferLakupandaiVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(requestTransferLakupandaiVM.alertMessage)
            }
            .alert(isPresented: $requestTransferLakupandaiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(requestTransferLakupandaiVM.alertMessage),
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
                                requestTransferLakupandaiVM.validateForm()
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

struct RequestTransferLakupandaiView_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransferLakupandaiView()
    }
}

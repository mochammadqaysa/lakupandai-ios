//
//  RequestTarikTunaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI
import AlertToast

struct RequestTarikTunaiView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var requestTarikTunaiVM = RequestTarikTunaiViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                Form {
                    ZStack(alignment: .leading) {
                        Text("No HP Nasabah")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: requestTarikTunaiVM.noTelpon.isEmpty)
                            .offset(y: requestTarikTunaiVM.noTelpon.isEmpty ? 0 : -20)
                        TextField("", text: $requestTarikTunaiVM.noTelpon)
                            .keyboardType(.numberPad)
                            .onChange(of: requestTarikTunaiVM.noTelpon){newValue in
                                if newValue.count > 13 {
                                    requestTarikTunaiVM.noTelpon = String(newValue.prefix(13))
                                }
                            }
                    }
                    .padding(.top, requestTarikTunaiVM.noTelpon.isEmpty ? 0 : 22)
                    
                    ZStack(alignment: .leading) {
                        Text("Nominal")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: requestTarikTunaiVM.nominal.isEmpty)
                            .offset(y: requestTarikTunaiVM.nominal.isEmpty ? 0 : -20)
                        TextField("", text: $requestTarikTunaiVM.nominal)
                            .keyboardType(.numberPad)
                    }
                    .padding(.top, requestTarikTunaiVM.nominal.isEmpty ? 0 : 22)
                    
                    ZStack(alignment: .leading) {
                        Text("PIN")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: requestTarikTunaiVM.pinAgen.isEmpty)
                            .offset(y: requestTarikTunaiVM.pinAgen.isEmpty ? 0 : -20)
                        SecureField("", text: $requestTarikTunaiVM.pinAgen)
                            .keyboardType(.numberPad)
                            .onChange(of: requestTarikTunaiVM.pinAgen){newValue in
                                if newValue.count > 6 {
                                    requestTarikTunaiVM.pinAgen = String(newValue.prefix(6))
                                }
                            }
                    }
                    .padding(.top, requestTarikTunaiVM.pinAgen.isEmpty ? 0 : 22)
                }
                .scrollContentBackground(.hidden)
            }
            .toast(isPresenting: $requestTarikTunaiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $requestTarikTunaiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(requestTarikTunaiVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $requestTarikTunaiVM.showToastResponse) {
                Alert(
                    title: Text("INFORMASI"),
                    message: Text(requestTarikTunaiVM.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
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
                            requestTarikTunaiVM.validateForm()
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

struct RequestTarikTunaiView_Previews: PreviewProvider {
    static var previews: some View {
        RequestTarikTunaiView()
    }
}

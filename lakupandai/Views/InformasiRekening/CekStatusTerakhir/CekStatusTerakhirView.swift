//
//  CekStatusTerakhirView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI
import AlertToast

struct CekStatusTerakhirView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cekStatusTerakhirVM = CekStatusTerakhirViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: DetailStatusTerakhirView(dataSaldo: cekStatusTerakhirVM.dataStatus, layanan : cekStatusTerakhirVM.layanan),
                        isActive: $cekStatusTerakhirVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    
                    
                    Form {
                        ZStack(alignment: .leading) {
                            Text("No HP Nasabah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: cekStatusTerakhirVM.noTelpon.isEmpty)
                                .offset(y: cekStatusTerakhirVM.noTelpon.isEmpty ? 0 : -20)
                            TextField("", text: $cekStatusTerakhirVM.noTelpon)
                                .keyboardType(.phonePad)
                                .onChange(of: cekStatusTerakhirVM.noTelpon){newValue in
                                    if newValue.count > 13 {
                                        cekStatusTerakhirVM.noTelpon = String(newValue.prefix(13))
                                    }
                                }
                        }
                        .padding(.top, cekStatusTerakhirVM.noTelpon.isEmpty ? 0 : 22)
                        ZStack(alignment: .leading) {
                            Text("PIN")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: cekStatusTerakhirVM.pinAgen.isEmpty)
                                .offset(y: cekStatusTerakhirVM.pinAgen.isEmpty ? 0 : -20)
                            SecureField("", text: $cekStatusTerakhirVM.pinAgen)
                                .keyboardType(.numberPad)
                                .onChange(of: cekStatusTerakhirVM.pinAgen){newValue in
                                    if newValue.count > 6 {
                                        cekStatusTerakhirVM.pinAgen = String(newValue.prefix(6))
                                    }
                                }
                        }
                        .padding(.top, cekStatusTerakhirVM.pinAgen.isEmpty ? 0 : 22)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .toast(isPresenting: $cekStatusTerakhirVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $cekStatusTerakhirVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(cekStatusTerakhirVM.alertMessage),
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
                        Text("CEK STATUS TERAKHIR")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                        .foregroundColor(.white)
                        .onTapGesture {
                            cekStatusTerakhirVM.validateForm()
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

struct CekStatusTerakhirView_Previews: PreviewProvider {
    static var previews: some View {
        CekStatusTerakhirView()
    }
}

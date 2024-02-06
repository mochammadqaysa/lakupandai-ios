//
//  KonfirmasiRequestTransferBPDView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 18/01/24.
//

import SwiftUI
import AlertToast

struct KonfirmasiRequestTransferBPDView: View {
    let dataTransferDari : [ItemValue]
    let dataTransferKe : [ItemValue]
    let tokenNasabah : String
    var onDismiss: (Bool) -> Void
    @Binding var navigateBack: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @StateObject var konfirmasiRequestTransferBPDVM = KonfirmasiRequestTransferBPDViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
//                        NavigationLink(
//                            destination: HasilTarikTunaiView(dataHasil: konfirmasiTarikTunaiDetailVM.dataTarikTunai, layanan: konfirmasiTarikTunaiDetailVM.dataLayanan),
//                            isActive: $konfirmasiTarikTunaiDetailVM.nextStep,
//                            label: { EmptyView() }
//                        ).hidden()
                    }
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.gray.opacity(0.2))
                            .shadow(radius: 3)
                        VStack(alignment: .leading) {
                            Text("TRANSFER DANA")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Spacer()
                            Text("Dari")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 5) {
                                ForEach(dataTransferDari) { item in
                                    GridRow() {
                                        Text(item.header)
                                        Text(":")
                                        Text(item.value)
                                            .bold()
                                    }
                                }
                            }
                            Text("Ke")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                            Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 5) {
                                ForEach(dataTransferKe) { item in
                                    GridRow() {
                                        Text(item.header)
                                        Text(":")
                                        Text(item.value)
                                            .bold()
                                    }
                                }
                            }
                            .padding(.bottom,60)
                            VStack(alignment: .center){
                                ZStack(alignment: .center) {
                                    if konfirmasiRequestTransferBPDVM.pinAgen.isEmpty {
                                        Text("Masukan PIN Agen")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiRequestTransferBPDVM.pinAgen)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: konfirmasiRequestTransferBPDVM.pinAgen){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiRequestTransferBPDVM.pinAgen = String(newValue.prefix(6))
                                            }
                                        }
                                }
                                .padding(15)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                            .background(.white)
                            .padding(.top,20)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                }
                .alert(isPresented: $konfirmasiRequestTransferBPDVM.showAlert){
                    Alert(
                        title: Text("Peringatan"),
                        message: Text(konfirmasiRequestTransferBPDVM.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .alert("Peringatan", isPresented: $konfirmasiRequestTransferBPDVM.showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(konfirmasiRequestTransferBPDVM.alertMessage)
                }
                .alert(isPresented: $konfirmasiRequestTransferBPDVM.showToastResponse) {
                    Alert(
                        title: Text("INFORMASI"),
                        message: Text(konfirmasiRequestTransferBPDVM.alertMessage),
                        dismissButton: .default(Text("OK")) {
                            onDismiss(true)
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .alert("INFORMASI", isPresented: $konfirmasiRequestTransferBPDVM.showToastResponse) {
                    Button("OK", role: .cancel) {
                        onDismiss(true)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text(konfirmasiRequestTransferBPDVM.alertMessage)
                }
                .toast(isPresenting: $konfirmasiRequestTransferBPDVM.isLoading) {
                    AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
                }
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
                        Text("KONFIRMASI TRANSFER")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                konfirmasiRequestTransferBPDVM.validateForm(token: self.tokenNasabah)
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

struct KonfirmasiRequestTransferBPDView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiRequestTransferBPDView(dataTransferDari: [ItemValue(header: "Layanan", value: "Transfer Data"),], dataTransferKe: [ItemValue(header: "Nama", value: "India")], tokenNasabah: "",onDismiss: {_ in
            
        }, navigateBack: .constant(false))
    }
}

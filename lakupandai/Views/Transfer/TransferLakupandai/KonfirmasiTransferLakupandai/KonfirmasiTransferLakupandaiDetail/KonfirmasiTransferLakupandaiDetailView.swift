//
//  KonfirmasiTransferLakupandaiDetailView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 23/01/24.
//

import SwiftUI
import AlertToast

struct KonfirmasiTransferLakupandaiDetailView: View {
    let dataTransferDari : [ItemValue]
    let dataTransferKe : [ItemValue]
    let tokenNasabah : String
    let layanan : String
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @StateObject var konfirmasiTrasnferLakupandaiDetailVM = KonfirmasiTransferLakupandaiDetailViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        
                        NavigationLink(
                            destination: HasilTransferLakupandaiView(dataHasil: konfirmasiTrasnferLakupandaiDetailVM.dataTransfer, layanan: konfirmasiTrasnferLakupandaiDetailVM.dataLayanan),
                            isActive: $konfirmasiTrasnferLakupandaiDetailVM.nextStep,
                            label: { EmptyView() }
                        ).hidden()
                    }
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.gray.opacity(0.2))
                            .shadow(radius: 3)
                        VStack(alignment: .leading) {
                            Text("KONFIRMASI TRANSFER DANA")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Spacer()
                            Image("ic_logo_diy")
                                .resizable()
                                .frame(width: 120, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Grid(alignment: .topLeading,horizontalSpacing: 30, verticalSpacing: 5) {
                                GridRow() {
                                    Text("Layanan")
                                    Text(":")
                                    Text(layanan)
                                        .bold()
                                }
                            }
                            Text("Dari")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Grid(alignment: .leading,horizontalSpacing: 30, verticalSpacing: 5) {
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
                            Grid(alignment: .leading,horizontalSpacing: 30, verticalSpacing: 5) {
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
                                    if konfirmasiTrasnferLakupandaiDetailVM.pinAgen.isEmpty {
                                        Text("Masukan PIN Agen")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiTrasnferLakupandaiDetailVM.pinAgen)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: konfirmasiTrasnferLakupandaiDetailVM.pinAgen){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiTrasnferLakupandaiDetailVM.pinAgen = String(newValue.prefix(6))
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
                .alert(isPresented: $konfirmasiTrasnferLakupandaiDetailVM.showAlert){
                    Alert(
                        title: Text("Peringatan"),
                        message: Text(konfirmasiTrasnferLakupandaiDetailVM.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .alert("Peringatan", isPresented: $konfirmasiTrasnferLakupandaiDetailVM.showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(konfirmasiTrasnferLakupandaiDetailVM.alertMessage)
                }
                .alert(isPresented: $konfirmasiTrasnferLakupandaiDetailVM.showToastResponse) {
                    Alert(
                        title: Text("INFORMASI"),
                        message: Text(konfirmasiTrasnferLakupandaiDetailVM.alertMessage),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .alert("INFORMASI", isPresented: $konfirmasiTrasnferLakupandaiDetailVM.showToastResponse) {
                    Button("OK", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text(konfirmasiTrasnferLakupandaiDetailVM.alertMessage)
                }
                .toast(isPresenting: $konfirmasiTrasnferLakupandaiDetailVM.isLoading) {
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
                                konfirmasiTrasnferLakupandaiDetailVM.validateForm(token: self.tokenNasabah)
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

struct KonfirmasiTransferLakupandaiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiTransferLakupandaiDetailView(dataTransferDari: [ItemValue(header: "Layanan", value: "Transfer Data"),], dataTransferKe: [ItemValue(header: "Nama", value: "India")], tokenNasabah: "", layanan: "Transfer dana")
    }
}

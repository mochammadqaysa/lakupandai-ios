//
//  DetailMutasiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/01/24.
//

import SwiftUI
import AlertToast

struct DetailMutasiView: View {
    let idNotif : Int
    let layanan : String
    @ObservedObject var detailMutasiVM = DetailMutasiViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack {}
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(radius: 3)
                        VStack {
                            HStack {
                                Image("logo_agen_bpd_diy")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                                .padding(.trailing)
                                Text(UserDefaultsManager.shared.getString(forKey: ConstantTransaction.USER_SESSION_AGENT_NAME) ?? "")
                                    .font(.title)
                                    .foregroundColor(Color("colorPrimary"))
                                    .fontWeight(.light)
                            }
                            .padding(.vertical)
                            Text(self.layanan)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 15) {
                                ForEach(self.detailMutasiVM.listItem) { item in
                                    GridRow() {
                                        Text(item.header)
                                        Text(":")
                                        Text(item.value)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .lineLimit(nil)
                                    }
                                }
                            }
                            Spacer()
                            Text("Informasi Lebih Lanjut, Silakan Hubungi\nBPD DIY Contact Center : 1500061\nSilakan Simpan Resi Ini\nSebagai Bukti Pembayaran Yang Sah")
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                        .padding(.horizontal)
                }
            }
            .onAppear {
                self.detailMutasiVM.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.detailMutasiVM.initData(idNotif: self.idNotif)
                    self.detailMutasiVM.isLoading = false
                }
            }
            .blur(radius: detailMutasiVM.isLoading ? 20 : 0)
            .toast(isPresenting: $detailMutasiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $detailMutasiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(detailMutasiVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Button(action: {
//                            onDismiss(true)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        Spacer()
                        Text("DETAIL MUTASI")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Selesai")
                            .font(Font.footnote)
                            .bold()
                        .foregroundColor(.white)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
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

struct DetailMutasiView_Previews: PreviewProvider {
    static var previews: some View {
        DetailMutasiView(idNotif: 0, layanan: "")
    }
}

//
//  NotificationDetailView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import SwiftUI
import AlertToast
import Printer
//import Printer

struct NotificationDetailView: View {
    let idNotif : Int
    let layanan : String
    @ObservedObject var notificationDetailVM = NotificationDetailViewModel()
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
                                ForEach(notificationDetailVM.listItem) { item in
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
                                .padding(.bottom,20)
                            VStack{
                                
                                Button(action: {
                                    var ticket = Receipt(.🖨️58())
        //                            loginVM.validateForm()
                                }) {
                                    Image(systemName: "printer")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 50, height: 50)
                                .background(.green)
                                .clipShape(Circle())
                            }
                            .padding(.bottom, -40)
                        }
                        .padding()
                        
                        
                    }
                        .padding(.horizontal)
                    
                        VStack {}
                            .frame(height: 30)
                }
            }
            .onAppear {
                self.notificationDetailVM.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.notificationDetailVM.initData(idNotif: self.idNotif)
                    self.notificationDetailVM.isLoading = false
                }
            }
            .blur(radius: notificationDetailVM.isLoading ? 20 : 0)
            .toast(isPresenting: $notificationDetailVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $notificationDetailVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(notificationDetailVM.alertMessage),
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
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct NotificationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationDetailView(idNotif: 0, layanan: "Layanan")
    }
}

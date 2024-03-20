//
//  NotificationView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import SwiftUI
import AlertToast

struct NotificationView: View {
    
    
    @ObservedObject var notificationVM = NotificationViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack{
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack{}.padding(.top,15)
                    LazyVStack {
                        ForEach(Array(notificationVM.dataNotif.enumerated()), id: \.element.id) { index, item in
                            NavigationLink(destination: NotificationDetailView(idNotif: item.id_notif, layanan: item.layanan)) {
                                RowNotification(notif: item)
                                    .foregroundColor(.black)
                            }
                            
                        }
                    }
                }
            }
            .alert(isPresented: $notificationVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(notificationVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert("Peringatan", isPresented: $notificationVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(notificationVM.alertMessage)
            }
            .alert(isPresented: $notificationVM.showToastResponse) {
                Alert(
                    title: Text("INFORMASI"),
                    message: Text(notificationVM.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .alert("INFORMASI", isPresented: $notificationVM.showToastResponse) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text(notificationVM.alertMessage)
            }
            .toast(isPresenting: $notificationVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        Spacer()
                        .foregroundColor(.white)
                        Image("ic_logo_diy_white")
                            .resizable()
                            .frame(width: 150, height: 35)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Spacer()
                    }
                    .foregroundColor(.white)
                }
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

//
//  NotificationView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import SwiftUI

struct NotificationView: View {
    
    
    @ObservedObject var notificationVM = NotificationViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack{
            List{
                VStack(alignment: .center){
                    HStack{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color("colorDarkBlue"))
                        Text("Telkomsel Prepaid")
                        Spacer()
                        Text("(D) Rp. 53.000")
                    }
                    HStack{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color("colorAccent"))
                        Text("02-11-2022")
                        Spacer()
                        Text("Resi. 2022112344353")
                    }
                }
                .onTapGesture {
                    notificationVM.showNotificationDetail.toggle()
                }
                .fullScreenCover(isPresented: $notificationVM.showNotificationDetail){
                    NotificationDetailView()
                }
                VStack(alignment: .center){
                    HStack{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color("colorAccent"))
                        Text("Telkomsel Prepaid")
                        Spacer()
                        Text("(D) Rp. 53.000")
                    }
                    HStack{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color("colorAccent"))
                        Text("02-11-2022")
                        Spacer()
                        Text("Resi. 2022112344353")
                    }
                }
                VStack(alignment: .center){
                    HStack{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color("colorAccent"))
                        Text("Telkomsel Prepaid")
                        Spacer()
                        Text("(D) Rp. 53.000")
                    }
                    HStack{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color("colorAccent"))
                        Text("02-11-2022")
                        Spacer()
                        Text("Resi. 2022112344353")
                    }
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack(spacing:50) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        Image("ic_logo_diy_white")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("")
                    }
                    .foregroundColor(.white)
                }
            }
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

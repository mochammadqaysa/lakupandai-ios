//
//  NotificationDetailView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import SwiftUI

struct NotificationDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(radius: 3)
                    
                    VStack {
                        HStack {
                            Image("logo_agen_bpd_diy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            Text("Nama  Debitur")
                                .font(.title)
                                .foregroundColor(Color("colorPrimary"))
                                .fontWeight(.light)
                        }
                        Text("Telkomsel Paket Data")
                        HStack {
                            Text("No Resi")
                            Text(":")
                            Text("No Resi")
                        }
                        HStack {
                            Text("Waktu")
                            Spacer()
                        }
                        HStack {
                            Text("No HP")
                            Spacer()
                        }
                        HStack {
                            Text("Nominal")
                            Spacer()
                        }
                        HStack {
                            Text("Biaya Admin")
                            Spacer()
                        }
                        HStack {
                            Text("Jumlah Bayar")
                            Spacer()
                        }
                        HStack {
                            Text("SN")
                            Spacer()
                        }
                        HStack {
                            Text("Status")
                            Spacer()
                        }
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                }
                .frame( height: 520)
                .padding(.horizontal)
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack(spacing:55) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        
                        Text("DETAIL NOTIFIKASI")
                            .font(.title3)
                            .fontWeight(.bold)
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
        NotificationDetailView()
    }
}

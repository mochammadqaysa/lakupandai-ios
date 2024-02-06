//
//  TarikTunaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI

struct TarikTunaiView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                List {
                    NavigationLink(destination: LazyView { RequestTarikTunaiView() }) {
                        HStack(spacing:20) {
                            Image("tarik_tunai")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Request Tarik Tunai")
                        }
                    }
                    NavigationLink(destination: LazyView { KonfirmasiTarikTunaiView() }){
                        HStack(spacing:20) {
                            Image("konfirmasitariktunai")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Konfirmasi Tarik Tunai")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
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
                        Text("TARIK TUNAI")
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

struct TarikTunaiView_Previews: PreviewProvider {
    static var previews: some View {
        TarikTunaiView()
    }
}

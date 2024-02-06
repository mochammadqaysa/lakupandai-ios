//
//  MenuTransferBank.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI

struct MenuTransferBank: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                List {
                    NavigationLink(destination: LazyView { RequestTransferBankView() }){
                        HStack(spacing:20) {
                            Image("transferrekbanklain")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Request Transfer")
                        }
                    }
                    NavigationLink(destination: LazyView { KonfirmasiTransferBankView() }){
                        HStack(spacing:20) {
                            Image("konfirmasitariktunai")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Konfirmasi Transfer")
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
                        Text("TRANSFER ANTAR BANK")
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

struct MenuTransferBank_Previews: PreviewProvider {
    static var previews: some View {
        MenuTransferBank()
    }
}

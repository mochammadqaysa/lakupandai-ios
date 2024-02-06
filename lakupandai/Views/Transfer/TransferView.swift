//
//  TransferView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI

struct TransferView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                List {
                    NavigationLink(destination: MenuTransferBPD()) {
                        HStack(spacing:20) {
                            Image("transferrekbankjatim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Transfer ke Rek BPD DIY")
                        }
                    }
                    NavigationLink(destination: MenuTransferLakupandai()){
                        HStack(spacing:20) {
                            Image("transferrekbanklain")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Transfer ke Rek Lakupandai")
                        }
                    }
                    NavigationLink(destination: MenuTransferBank()){
                        HStack(spacing:20) {
                            Image("transferkebanklain")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Transfer Antar Bank")
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
                        Text("TRANSFER")
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

struct TransferView_Previews: PreviewProvider {
    static var previews: some View {
        TransferView()
    }
}

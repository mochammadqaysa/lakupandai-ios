//
//  SetorTunaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI

struct SetorTunaiView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                List {
                    NavigationLink(destination: SetorLakupandaiView()) {
                        HStack(spacing:20) {
                            Image("option_setor")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Setor ke Nasabah Lakupandai")
                        }
                    }
                    NavigationLink(destination: SetorBPDView()){
                        HStack(spacing:20) {
                            Image("option_setor")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Setor ke Nasabah Reguler BPD DIY")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
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
                        Text("SETOR TUNAI")
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

struct SetorTunaiView_Previews: PreviewProvider {
    static var previews: some View {
        SetorTunaiView()
    }
}

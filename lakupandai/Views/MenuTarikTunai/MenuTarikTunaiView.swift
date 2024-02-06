//
//  MenuTarikTunaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 28/12/23.
//

import SwiftUI

struct MenuTarikTunaiView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                List {
                    NavigationLink(destination: LazyView { TarikTunaiView() }) {
                        HStack(spacing:20) {
                            Image("tarik_tunai")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Tarik Tunai")
                        }
                    }
                    NavigationLink(destination: LazyView { TarikTunaiTanpaKartuView() }){
                        HStack(spacing:20) {
                            Image("tarik_tunai_tanpa_kartu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            Text("Tarik Tunai Tanpa Kartu")
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

struct MenuTarikTunaiView_Previews: PreviewProvider {
    static var previews: some View {
        MenuTarikTunaiView()
    }
}

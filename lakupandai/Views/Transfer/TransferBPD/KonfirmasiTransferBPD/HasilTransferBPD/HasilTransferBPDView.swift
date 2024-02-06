//
//  HasilTransferBPDView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 22/01/24.
//

import SwiftUI

struct HasilTransferBPDView: View {
    let dataHasil : [ItemValue]
    let layanan : String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    VStack{
                        Text("TRANSFER")
                            .font(.title2)
                            .bold()
                            .padding(.bottom)
                        Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 10) {
                            GridRow() {
                                Text("Layanan")
                                Text(":")
                                Text(layanan)
                            }
                            ForEach(dataHasil) { item in
                                GridRow() {
                                    Text(item.header)
                                    Text(":")
                                    Text(item.value)
                                }
                            }
                        }
                        .padding(.bottom,60)
                        
                        
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    .padding(.top,35)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        Spacer()
                        Text("RESPON PESAN")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Selesai")
                            .font(Font.footnote)
                            .bold()
                        .foregroundColor(.white)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
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

struct HasilTransferBPDView_Previews: PreviewProvider {
    static var previews: some View {
        HasilTransferBPDView(dataHasil: [], layanan: "Transfer Dana")
    }
}

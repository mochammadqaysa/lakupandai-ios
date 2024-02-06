//
//  HasilTarikTunaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 16/01/24.
//

import SwiftUI
import AlertToast

struct HasilTarikTunaiView: View {
    let dataHasil : [ItemValue]
    let layanan : String
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var hasilTarikTunaiVM = HasilTarikTunaiViewModel()
    var body: some View {
        NavigationStack {
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    VStack{
                        Text(layanan)
                            .font(.title2)
                            .bold()
                            .padding(.bottom)
                        Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 15) {
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
            .toast(isPresenting: $hasilTarikTunaiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $hasilTarikTunaiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(hasilTarikTunaiVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
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

struct HasilTarikTunaiView_Previews: PreviewProvider {
    static var previews: some View {
        HasilTarikTunaiView(dataHasil: [], layanan: "Penarikan Dana")
    }
}

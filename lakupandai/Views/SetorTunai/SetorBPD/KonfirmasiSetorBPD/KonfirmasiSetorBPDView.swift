//
//  KonfirmasiSetorBPDView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 08/01/24.
//

import SwiftUI
import AlertToast

struct KonfirmasiSetorBPDView: View {
    let dataSetor : [ItemValue]
    let token : String
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var konfirmasiSetorBPDVM = KonfirmasiSetorBPDViewModel()
    var body: some View {
        NavigationStack {
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    VStack{
                        Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 15) {
                            ForEach(dataSetor) { item in
                                GridRow() {
                                    Text(item.header)
                                    Text(":")
                                    Text(item.value)
                                }
                            }
                        }
                        .padding(.bottom,60)
                        
                        
                        VStack(alignment: .center){
                            ZStack(alignment: .center) {
                                if konfirmasiSetorBPDVM.pinAgen.isEmpty {
                                    Text("PIN")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .italic()
                                }
                                SecureField("", text: $konfirmasiSetorBPDVM.pinAgen)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .onChange(of: konfirmasiSetorBPDVM.pinAgen){newValue in
                                        if newValue.count > 6 {
                                            konfirmasiSetorBPDVM.pinAgen = String(newValue.prefix(6))
                                        }
                                    }
                            }
                            .padding(15)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                        .background(.white)
                        .padding(.top,20)
                        
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    .padding(.top,35)
                }
            }
            .toast(isPresenting: $konfirmasiSetorBPDVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $konfirmasiSetorBPDVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiSetorBPDVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $konfirmasiSetorBPDVM.showToastResponse) {
                Alert(
                    title: Text("INFORMASI"),
                    message: Text(konfirmasiSetorBPDVM.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
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
                        Text("KONFIRMASI SETOR TUNAI")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                konfirmasiSetorBPDVM.validateForm(dataToken: self.token)
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

struct KonfirmasiSetorBPDView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiSetorBPDView(dataSetor: [], token: "")
    }
}

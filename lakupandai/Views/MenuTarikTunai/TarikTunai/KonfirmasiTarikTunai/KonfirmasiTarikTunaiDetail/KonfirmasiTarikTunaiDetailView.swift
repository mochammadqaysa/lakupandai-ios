//
//  KonfirmasiTarikTunaiDetailView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 16/01/24.
//

import SwiftUI
import AlertToast

struct KonfirmasiTarikTunaiDetailView: View {
    let dataTarik : [ItemValue]
    let tokenNasabah : String
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var konfirmasiTarikTunaiDetailVM = KonfirmasiTarikTunaiDetailViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        NavigationLink(
                            destination: HasilTarikTunaiView(dataHasil: konfirmasiTarikTunaiDetailVM.dataTarikTunai, layanan: konfirmasiTarikTunaiDetailVM.dataLayanan),
                            isActive: $konfirmasiTarikTunaiDetailVM.nextStep,
                            label: { EmptyView() }
                        ).hidden()
                    }
                        .frame(height: 20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.gray.opacity(0.2))
                            .shadow(radius: 3)
                        VStack {
                            Text("KONFIRMASI TARIK TUNAI")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Spacer()
                            Grid(alignment: .leadingFirstTextBaseline,horizontalSpacing: 30, verticalSpacing: 15) {
                                ForEach(dataTarik) { item in
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
                                    if konfirmasiTarikTunaiDetailVM.pinAgen.isEmpty {
                                        Text("Masukan PIN Agen")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .italic()
                                    }
                                    SecureField("", text: $konfirmasiTarikTunaiDetailVM.pinAgen)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: konfirmasiTarikTunaiDetailVM.pinAgen){newValue in
                                            if newValue.count > 6 {
                                                konfirmasiTarikTunaiDetailVM.pinAgen = String(newValue.prefix(6))
                                            }
                                        }
                                }
                                .padding(15)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                            .background(.white)
                            .padding(.top,20)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                }
            }
            .toast(isPresenting: $konfirmasiTarikTunaiDetailVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $konfirmasiTarikTunaiDetailVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(konfirmasiTarikTunaiDetailVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
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
                        Text("KONFIRMASI TARIK TUNAI")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                konfirmasiTarikTunaiDetailVM.validateForm(token: self.tokenNasabah)
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
func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
    return dateFormatter.string(from: date)
}

struct KonfirmasiTarikTunaiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KonfirmasiTarikTunaiDetailView(dataTarik: [ItemValue(header: "asd", value: formatDate(date: Date()))], tokenNasabah: "")
    }
}

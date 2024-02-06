//
//  SetorLakupandaiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI
import AlertToast

struct SetorLakupandaiView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var setorLakupandaiVM = SetorLakupandaiViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: KonfirmasiSetorLakupandaiView(dataSetor: setorLakupandaiVM.dataSetor, token: setorLakupandaiVM.token),
                        isActive: $setorLakupandaiVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    Form {
                        ZStack(alignment: .leading) {
                            Text("No HP Nasabah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: setorLakupandaiVM.noTelpon.isEmpty)
                                .offset(y: setorLakupandaiVM.noTelpon.isEmpty ? 0 : -20)
                            TextField("", text: $setorLakupandaiVM.noTelpon)
                                .keyboardType(.numberPad)
                                .onChange(of: setorLakupandaiVM.noTelpon){newValue in
                                    if newValue.count > 13 {
                                        setorLakupandaiVM.noTelpon = String(newValue.prefix(13))
                                    }
                                }
                        }
                        .padding(.top, setorLakupandaiVM.noTelpon.isEmpty ? 0 : 22)
                        ZStack(alignment: .leading) {
                            Text("Nominal")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: setorLakupandaiVM.nominal.isEmpty)
                                .offset(y: setorLakupandaiVM.nominal.isEmpty ? 0 : -20)
                            TextField("", text: $setorLakupandaiVM.nominal)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, setorLakupandaiVM.nominal.isEmpty ? 0 : 22)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .toast(isPresenting: $setorLakupandaiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $setorLakupandaiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(setorLakupandaiVM.alertMessage),
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
                        Text("SETOR TUNAI")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                setorLakupandaiVM.validateForm()
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

struct SetorLakupandaiView_Previews: PreviewProvider {
    static var previews: some View {
        SetorLakupandaiView()
    }
}

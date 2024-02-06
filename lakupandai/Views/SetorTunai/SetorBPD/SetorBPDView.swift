//
//  SetorBPDView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI
import AlertToast

struct SetorBPDView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var setorBPDVM = SetorBPDViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: KonfirmasiSetorBPDView(dataSetor: setorBPDVM.dataSetor, token: setorBPDVM.token),
                        isActive: $setorBPDVM.nextStep,
                        label: { EmptyView() }
                    ).hidden()
                    
                    Form {
                        ZStack(alignment: .leading) {
                            Text("No Rekening Nasabah")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: setorBPDVM.noRek.isEmpty)
                                .offset(y: setorBPDVM.noRek.isEmpty ? 0 : -20)
                            TextField("", text: $setorBPDVM.noRek)
                                .keyboardType(.numberPad)
                                .onChange(of: setorBPDVM.noRek){newValue in
                                    if newValue.count > 13 {
                                        setorBPDVM.noRek = String(newValue.prefix(13))
                                    }
                                }
                        }
                        .padding(.top, setorBPDVM.noRek.isEmpty ? 0 : 22)
                        ZStack(alignment: .leading) {
                            Text("Nominal")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: setorBPDVM.nominal.isEmpty)
                                .offset(y: setorBPDVM.nominal.isEmpty ? 0 : -20)
                            TextField("", text: $setorBPDVM.nominal)
                                .keyboardType(.numberPad)
                        }
                        .padding(.top, setorBPDVM.nominal.isEmpty ? 0 : 22)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .toast(isPresenting: $setorBPDVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $setorBPDVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(setorBPDVM.alertMessage),
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
                            setorBPDVM.validateForm()
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

struct SetorBPDView_Previews: PreviewProvider {
    static var previews: some View {
        SetorBPDView()
    }
}

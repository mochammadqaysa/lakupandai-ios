//
//  HomeView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var homeVM = HomeViewModel()
    @Binding var isLogin: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack(){
                    ImageSlider()
                        .frame(height: 140)
                    LazyVGrid(columns: homeVM.columns) {
                        SingleMenu(sourceImage: "ic_buka_rekening_baru", title: "Aktivasi Rekening Baru")
                            .onTapGesture {
                                homeVM.showAktivasiRekeningBaru.toggle()
                            }
                        SingleMenu(sourceImage: "ic_informasi_rekening", title: "Informasi Rekening")
                            .onTapGesture {
                                homeVM.showInformasiRekening.toggle()
                            }
                        SingleMenu(sourceImage: "ic_setor_tunai", title: "Setor Tunai")
                            .onTapGesture {
                                homeVM.showSetorTunai.toggle()
                            }
                        SingleMenu(sourceImage: "ic_tarik_tunai", title: "Tarik Tunai")
                            .onTapGesture {
                                homeVM.showTarikTunai.toggle()
                            }
                        SingleMenu(sourceImage: "ic_transfer", title: "Transfer")
                            .onTapGesture {
                                homeVM.showTransfer.toggle()
                            }
                        SingleMenu(sourceImage: "ic_pembelian", title: "Pembelian")
                            .onTapGesture {
                                homeVM.showPembelian.toggle()
                            }
                        SingleMenu(sourceImage: "ic_pembayaran", title: "Pembayaran")
                            .onTapGesture {
                                homeVM.showPembayaran.toggle()
                            }
                    }
                    .padding(.top,10)
                    .padding(.horizontal,20)
                    Spacer()
                }
                NavigationDrawer(isOpen: homeVM.isDrawerOpen, isLogin: self.$isLogin)
                    .background(.black.opacity(homeVM.isDrawerOpen ? 0.5 : 0))
                    .edgesIgnoringSafeArea(.bottom)
                
            }
            .gesture(TapGesture().onEnded {
                withAnimation {
                    homeVM.isDrawerOpen = false
                }
            })
            .fullScreenCover(isPresented: $homeVM.showAktivasiRekeningBaru) {
                AktivasiRekeningBaruView()
            }
            .fullScreenCover(isPresented: $homeVM.showInformasiRekening) {
                InformasiRekeningView()
            }
            .fullScreenCover(isPresented: $homeVM.showSetorTunai) {
                SetorTunaiView()
            }
            .fullScreenCover(isPresented: $homeVM.showTarikTunai) {
                MenuTarikTunaiView()
            }
            .fullScreenCover(isPresented: $homeVM.showTransfer) {
                TransferView()
            }
            .fullScreenCover(isPresented: $homeVM.showPembelian){
                PembelianView()
            }
            .fullScreenCover(isPresented: $homeVM.showPembayaran){
                PembayaranView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Button(action: {
                            withAnimation{
                                homeVM.isDrawerOpen.toggle()
                            }
                        }) {
                            !homeVM.isDrawerOpen ?
                            Image(systemName: "line.horizontal.3")
                            : Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        Image("ic_logo_diy_white")
                            .resizable()
                            .frame(width: 150, height: 35)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "bell.fill")
                        .foregroundColor(.white)
                        .onTapGesture {
                            homeVM.showNotification.toggle()
                        }
                        .fullScreenCover(isPresented: $homeVM.showNotification){
                            NotificationView()
                        }
                    }
                }
            }
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isLogin: .constant(true))
    }
}

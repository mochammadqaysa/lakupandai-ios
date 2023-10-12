//
//  HomeView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var homeVM = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(){
                    ImageSlider()
                        .frame(height: 140)
                    LazyVGrid(columns: homeVM.columns) {
                        SingleMenu(sourceImage: "ic_buka_rekening_baru", title: "Aktivasi Rekening Baru")
                        SingleMenu(sourceImage: "ic_informasi_rekening", title: "Informasi Rekening")
                        SingleMenu(sourceImage: "ic_setor_tunai", title: "Setor Tunai")
                        SingleMenu(sourceImage: "ic_tarik_tunai", title: "Tarik Tunai")
                        SingleMenu(sourceImage: "ic_transfer", title: "Transfer")
                        SingleMenu(sourceImage: "ic_pembelian", title: "Pembelian")
                        SingleMenu(sourceImage: "ic_pembayaran", title: "Pembayaran")
                    }
                    .padding(.horizontal,20)
                    Spacer()
                }
                NavigationDrawer(isOpen: homeVM.isDrawerOpen)
                    .background(.black.opacity(homeVM.isDrawerOpen ? 0.5 : 0))
                    .edgesIgnoringSafeArea(.bottom)
                
            }
            
            .simultaneousGesture(TapGesture().onEnded {
                withAnimation {
                    homeVM.isDrawerOpen = false
                }
            })
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
                            homeVM.isDrawerOpen.toggle()
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
        HomeView()
    }
}

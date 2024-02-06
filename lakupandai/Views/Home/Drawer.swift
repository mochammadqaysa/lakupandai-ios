//
//  Drawer.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 05/10/23.
//

import SwiftUI

struct Drawer: View {
    
    @ObservedObject var drawerVM = DrawerViewModel()
    @Binding var isLogin : Bool
    var body: some View {
        VStack {
                ScrollView{
                    Image("ic_user_white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                    Text("Lihat Profil")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.top,20)
                    Divider()
                        .frame(height: 2)
                        .background(.white)
                        .padding(.bottom)
                    VStack(alignment: .leading){
                        ForEach(drawerVM.items) { value in
                            SingleDrawerMenu(imageName: value.image, title: value.name) {
                                switch value.name {
                                case "Aktivasi Rekening Baru" :
                                    drawerVM.showAktivasiRekeningBaru.toggle()
                                    break
                                case "Informasi Rekening" :
                                    drawerVM.showInformasiRekening.toggle()
                                    break
                                case "Setor Tunai" :
                                    drawerVM.showSetorTunai.toggle()
                                    break
                                case "Tarik Tunai" :
                                    drawerVM.showTarikTunai.toggle()
                                    break
                                case "Transfer" :
                                    drawerVM.showTransfer.toggle()
                                    break
                                case "Pembelian" :
                                    drawerVM.showPembelian.toggle()
                                    break
                                case "Pembayaran" :
                                    drawerVM.showPembayaran.toggle()
                                    break
                                default:
                                    drawerVM.showAktivasiRekeningBaru.toggle()
                                    break
                                }
                            }
                                .padding(.bottom,10)
                        }
                        Divider()
                            .frame(height: 2)
                            .background(.white)
                            .padding(.bottom)
                        SingleDrawerMenu(imageName: "ic_log_out_white", title: "Logout") {
                            self.isLogin = false
                        }
                    }
                    .fullScreenCover(isPresented: $drawerVM.showAktivasiRekeningBaru) {
                        AktivasiRekeningBaruView()
                    }
                    Spacer()
                }
                .scrollIndicators(.hidden)
        }
//        .frame(width: 250)
        .padding(16)
        .background(Color("colorPrimary"))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Drawer_Previews: PreviewProvider {
    static var previews: some View {
        Drawer(isLogin: .constant(true))
    }
}

struct SingleDrawerMenu: View{
    var imageName: String
    var title: String
    var action: () -> Void
    init(imageName: String, title: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.title = title
        self.action = action
    }
    var body: some View{
        Button(action: self.action){
            HStack(spacing:20) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                Text(title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
    }
}

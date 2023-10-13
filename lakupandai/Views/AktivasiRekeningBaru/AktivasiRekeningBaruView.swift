//
//  AktivasiRekeningBaruView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import SwiftUI

struct AktivasiRekeningBaruView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var aktivasiRekeningBaruVM = AktivasiRekeningBaruViewModel()
    var body: some View {
        NavigationStack{
            ScrollView {
                formActivation
                    .padding()
                
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack(spacing:20) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle")
                        }
                        .foregroundColor(.white)
                        Text("AKTIVASI REKENING BARU")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    var formActivation : some View {
        return VStack{
            Group {
                VStack {
                    TextField("Nomor Induk Kependudukan", text: $aktivasiRekeningBaruVM.nik)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                VStack {
                    TextField("Nama", text: $aktivasiRekeningBaruVM.namaDebitur)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                VStack {
                    TextField("Jenis Kelamin", text: $aktivasiRekeningBaruVM.jenisKelamin)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                HStack(){
                    VStack {
                        TextField("Tempat Lahir", text: $aktivasiRekeningBaruVM.tempatLahir)
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                    VStack {
                        TextField("Tanggal Lahir", text: $aktivasiRekeningBaruVM.tanggalLahir)
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical)
                VStack {
                    TextField("Kode Pekerjaan", text: $aktivasiRekeningBaruVM.kodePekerjaan)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                VStack {
                    TextField("Kota / Kabupaten", text: $aktivasiRekeningBaruVM.kotaKab)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                HStack(){
                    VStack {
                        TextField("Kecamatan", text: $aktivasiRekeningBaruVM.kecamatan)
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                    VStack {
                        TextField("Kelurahan / Desa", text: $aktivasiRekeningBaruVM.kelurahanDes)
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical)
                VStack {
                    TextField("Status Perkawinan", text: $aktivasiRekeningBaruVM.statusPerkawinan)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                VStack {
                    TextField("Nama Ibu Kandung", text: $aktivasiRekeningBaruVM.namaIbu)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
            }
            Group {
                VStack {
                    TextField("Kode Pendidikan", text: $aktivasiRekeningBaruVM.kodePendidikan)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                
                VStack {
                    TextField("No Telp", text: $aktivasiRekeningBaruVM.nomorTelp)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
            }
            
            
        }
    }
}

struct AktivasiRekeningBaruView_Previews: PreviewProvider {
    static var previews: some View {
        AktivasiRekeningBaruView()
    }
}



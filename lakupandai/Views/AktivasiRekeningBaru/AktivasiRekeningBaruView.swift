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
                VStack{
                    ZStack(alignment: .leading) {
                        Text("Nomor Induk Kependudukan")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.nik.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.nik.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.nik)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.nik.isEmpty ? 0 : 22)
                    
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                
                VStack{
                    ZStack(alignment: .leading) {
                        Text("Nama")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.namaDebitur.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.namaDebitur.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.namaDebitur)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.namaDebitur.isEmpty ? 0 : 22)
                    
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                
                VStack {
                    ZStack(alignment: .leading) {
                        Text("Jenis Kelamin")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.jenisKelamin.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.jenisKelamin.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.jenisKelamin)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.jenisKelamin.isEmpty ? 0 : 22)
                    
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                HStack(){
                    VStack {
                        ZStack(alignment: .leading) {
                            Text("Tempat Lahir")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.tempatLahir.isEmpty)
                                .offset(y: aktivasiRekeningBaruVM.tempatLahir.isEmpty ? 0 : -20)
                            TextField("", text: $aktivasiRekeningBaruVM.tempatLahir)
                        }
                        .padding(.top, aktivasiRekeningBaruVM.tempatLahir.isEmpty ? 0 : 22)
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                    VStack {
                        ZStack(alignment: .leading) {
                            Text("Tanggal Lahir")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.tanggalLahir.isEmpty)
                                .offset(y: aktivasiRekeningBaruVM.tanggalLahir.isEmpty ? 0 : -20)
                            TextField("", text: $aktivasiRekeningBaruVM.tanggalLahir)
                        }
                        .padding(.top, aktivasiRekeningBaruVM.tanggalLahir.isEmpty ? 0 : 22)
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical)
                VStack {
                    ZStack(alignment: .leading) {
                        Text("Kode Pekerjaan")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.kodePekerjaan.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.kodePekerjaan.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.kodePekerjaan)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.kodePekerjaan.isEmpty ? 0 : 22)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                VStack {
                    ZStack(alignment: .leading) {
                        Text("Kota / Kabupaten")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.kotaKab.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.kotaKab.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.kotaKab)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.kotaKab.isEmpty ? 0 : 22)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                HStack(){
                    VStack {
                        ZStack(alignment: .leading) {
                            Text("Kecamatan")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.kecamatan.isEmpty)
                                .offset(y: aktivasiRekeningBaruVM.kecamatan.isEmpty ? 0 : -20)
                            TextField("", text: $aktivasiRekeningBaruVM.kecamatan)
                        }
                        .padding(.top, aktivasiRekeningBaruVM.kecamatan.isEmpty ? 0 : 22)
                        
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                    VStack {
                        ZStack(alignment: .leading) {
                            Text("Kelurahan / Desa")
                                .foregroundColor(.gray.opacity(0.5))
                                .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.kelurahanDes.isEmpty)
                                .offset(y: aktivasiRekeningBaruVM.kelurahanDes.isEmpty ? 0 : -20)
                            TextField("", text: $aktivasiRekeningBaruVM.kelurahanDes)
                        }
                        .padding(.top, aktivasiRekeningBaruVM.kelurahanDes.isEmpty ? 0 : 22)
                        Divider()
                            .background(.black)
                            .tint(.black)
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical)
                VStack {
                    ZStack(alignment: .leading) {
                        Text("Status Perkawinan")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.statusPerkawinan.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.statusPerkawinan.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.statusPerkawinan)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.statusPerkawinan.isEmpty ? 0 : 22)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                VStack {
                    ZStack(alignment: .leading) {
                        Text("Nama Ibu Kandung")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.namaIbu.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.namaIbu.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.namaIbu)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.namaIbu.isEmpty ? 0 : 22)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
            }
            Group {
                VStack {
                    ZStack(alignment: .leading) {
                        Text("Kode Pendidikan")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.kodePendidikan.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.kodePendidikan.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.kodePendidikan)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.kodePendidikan.isEmpty ? 0 : 22)
                    
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.vertical)
                
                VStack {
                    ZStack(alignment: .leading) {
                        Text("No Telp")
                            .foregroundColor(.gray.opacity(0.5))
                            .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.nomorTelp.isEmpty)
                            .offset(y: aktivasiRekeningBaruVM.nomorTelp.isEmpty ? 0 : -20)
                        TextField("", text: $aktivasiRekeningBaruVM.nomorTelp)
                    }
                    .padding(.top, aktivasiRekeningBaruVM.nomorTelp.isEmpty ? 0 : 22)
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



//
//  AktivasiRekeningBaruView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 12/10/23.
//

import SwiftUI

struct AktivasiRekeningBaruView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack{
            ScrollView {
                FormAktivasi()
                    .padding()
                VStack {
                    TextField("No Telp", text: .constant(""))
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
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
}

struct AktivasiRekeningBaruView_Previews: PreviewProvider {
    static var previews: some View {
        AktivasiRekeningBaruView()
    }
}


struct FormAktivasi: View {
    @State var nik = ""
    @State var namaDebitur = ""
    @State var jenisKelamin = ""
    @State var tempatLahir = ""
    @State var tanggalLahir = ""
    @State var kodePekerjaan = ""
    @State var kotaKab = ""
    @State var kecamatan = ""
    @State var kelurahanDes = ""
    @State var statusPerkawinan = ""
    @State var namaIbu = ""
    @State var kodePendidikan = ""
    @State var nomor = ""
    var body: some View{
        VStack{
            VStack {
                TextField("Nomor Induk Kependudukan", text: $nik)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            VStack {
                TextField("Nama", text: $namaDebitur)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            VStack {
                TextField("Jenis Kelamin", text: $jenisKelamin)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            HStack(){
                VStack {
                    TextField("Tempat Lahir", text: $tempatLahir)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                VStack {
                    TextField("Tanggal Lahir", text: $tanggalLahir)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical)
            VStack {
                TextField("Kode Pekerjaan", text: $kodePekerjaan)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            VStack {
                TextField("Kota / Kabupaten", text: $kotaKab)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            HStack(){
                VStack {
                    TextField("Kecamatan", text: $kecamatan)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
                VStack {
                    TextField("Kelurahan / Desa", text: $kelurahanDes)
                    Divider()
                        .background(.black)
                        .tint(.black)
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical)
            VStack {
                TextField("Status Perkawinan", text: $statusPerkawinan)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            VStack {
                TextField("Nama Ibu Kandung", text: $namaIbu)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            VStack {
                TextField("Kode Pendidikan", text: $kodePendidikan)
                Divider()
                    .background(.black)
                    .tint(.black)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            
        }
    }
}

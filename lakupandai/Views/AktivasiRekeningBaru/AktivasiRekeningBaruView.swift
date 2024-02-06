//
//  AktivasiRekeningBaruView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 25/12/23.
//

import SwiftUI
import AlertToast

struct AktivasiRekeningBaruView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var aktivasiRekeningBaruVM = AktivasiRekeningBaruViewModel()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(
                        destination: ResponseAktivasiView(dataAktivasi: aktivasiRekeningBaruVM.dataForm),
                        isActive: $aktivasiRekeningBaruVM.nextStep,
                        label: { EmptyView() } 
                    ).hidden()
                    
                    
                    Form {
                        
                        Group {
                            ZStack(alignment: .leading) {
                                Text("Nomor Induk Kependudukan")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.nik.isEmpty)
                                    .offset(y: aktivasiRekeningBaruVM.nik.isEmpty ? 0 : -20)
                                TextField("", text: $aktivasiRekeningBaruVM.nik)
                                    .keyboardType(.numberPad)
                                    .onChange(of: aktivasiRekeningBaruVM.nik){newValue in
                                        if newValue.count > 16 {
                                            aktivasiRekeningBaruVM.nik = String(newValue.prefix(16))
                                        }
                                    }
                            }
                            .padding(.top, aktivasiRekeningBaruVM.nik.isEmpty ? 0 : 22)
                            
                            ZStack(alignment: .leading) {
                                Text("Nama")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.namaDebitur.isEmpty)
                                    .offset(y: aktivasiRekeningBaruVM.namaDebitur.isEmpty ? 0 : -20)
                                TextField("", text: $aktivasiRekeningBaruVM.namaDebitur)
                            }
                            .padding(.top, aktivasiRekeningBaruVM.namaDebitur.isEmpty ? 0 : 22)
                            
                            Picker("Jenis Kelamin", selection: $aktivasiRekeningBaruVM.selectedJenisKelamin) {
                                ForEach(aktivasiRekeningBaruVM.listJenisKelamin, id: \.self) { item in
                                    if let jenis = item["keterangan"]! as? String {
                                        Text(jenis).tag(jenis)
                                    }
                                }
                            }
                            
                            ZStack(alignment: .leading) {
                                Text("Tempat Lahir")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.tempatLahir.isEmpty)
                                    .offset(y: aktivasiRekeningBaruVM.tempatLahir.isEmpty ? 0 : -20)
                                TextField("", text: $aktivasiRekeningBaruVM.tempatLahir)
                            }
                            .padding(.top, aktivasiRekeningBaruVM.tempatLahir.isEmpty ? 0 : 22)
                            
                            DatePicker("Tanggal Lahir", selection: $aktivasiRekeningBaruVM.tanggalLahir, displayedComponents: .date)
                            
                            Picker("Kode Pekerjaan", selection: $aktivasiRekeningBaruVM.selectedKodePekerjaan) {
                                if !aktivasiRekeningBaruVM.filteredListKerja.isEmpty {
                                    SearchBar(text: $aktivasiRekeningBaruVM.searchPekerjaan, placeholder: "Cari Pekerjaan")
                                }
                                ForEach(aktivasiRekeningBaruVM.filteredListKerja, id: \.self) { item in
                                    if let ket = item["keterangan"]! as? String {
                                        Text(ket).tag(ket)
                                    }
                                }
                            }
                            .pickerStyle(.navigationLink)
                            
                            Picker("Provinsi", selection: $aktivasiRekeningBaruVM.selectedProvinsi) {
                                SearchBar(text: $aktivasiRekeningBaruVM.searchProvinsi, placeholder: "Cari Provinsi")
                                    .accessibilityHidden(!aktivasiRekeningBaruVM.filteredListProvinsi.isEmpty)
                                ForEach(aktivasiRekeningBaruVM.filteredListProvinsi, id: \.self) { item in
                                    if let ket = item["keterangan"]! as? String {
                                        Text(ket).tag(ket)
                                    }
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .onChange(of: aktivasiRekeningBaruVM.selectedProvinsi) { newValue in
                                aktivasiRekeningBaruVM.onChangeProvinsi(newProvinsi: newValue)
                            }
                            
                            Picker("Kota / Kabupaten", selection: $aktivasiRekeningBaruVM.selectedKabupaten) {
                                if !aktivasiRekeningBaruVM.filteredListKabupaten.isEmpty {
                                    SearchBar(text: $aktivasiRekeningBaruVM.searchKabupaten, placeholder: "Cari Kabupaten")
                                }
                                ForEach(aktivasiRekeningBaruVM.filteredListKabupaten, id: \.self) { item in
                                    
                                    if let ket = item["keterangan"]! as? String {
                                        Text(ket).tag(ket)
                                    }
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .onChange(of: aktivasiRekeningBaruVM.selectedKabupaten) { newValue in
                                aktivasiRekeningBaruVM.onChangeKabupaten()
                            }
                            
                            Picker("Kecamatan", selection: $aktivasiRekeningBaruVM.selectedKecamatan) {
                                if !aktivasiRekeningBaruVM.filteredListKecamatan.isEmpty {
                                    SearchBar(text: $aktivasiRekeningBaruVM.searchKecamatan, placeholder: "Cari Kecamatan")
                                }
                                ForEach(aktivasiRekeningBaruVM.filteredListKecamatan, id: \.self) { item in
                                    if let ket = item["keterangan"]! as? String {
                                        Text(ket).tag(ket)
                                    }
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .onChange(of: aktivasiRekeningBaruVM.selectedKecamatan) { newValue in
                                aktivasiRekeningBaruVM.onChangeKecamatan(newKecamatan: newValue)
                            }
                            
                            Picker("Kelurahan / Desa", selection: $aktivasiRekeningBaruVM.selectedKelurahan) {
                                if !aktivasiRekeningBaruVM.filteredListKelurahan.isEmpty {
                                    SearchBar(text: $aktivasiRekeningBaruVM.searchKelurahan, placeholder: "Cari Kelurahan")
                                }
                                ForEach(aktivasiRekeningBaruVM.filteredListKelurahan, id: \.self) { item in
                                    if let ket = item["keterangan"]! as? String {
                                        Text(ket).tag(ket)
                                    }
                                }
                            }
                            .pickerStyle(.navigationLink)
                            
                            
                        }
                        Group {
                            Picker("Status Perkawinan", selection: $aktivasiRekeningBaruVM.selectedStatusPerkawinan) {
                                ForEach(aktivasiRekeningBaruVM.listKawin, id: \.self) { item in
                                    if let jenis = item["keterangan"]! as? String {
                                        Text(jenis).tag(jenis)
                                    }
                                }
                            }
                            ZStack(alignment: .leading) {
                                Text("Nama Ibu Kandung")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.namaIbu.isEmpty)
                                    .offset(y: aktivasiRekeningBaruVM.namaIbu.isEmpty ? 0 : -20)
                                TextField("", text: $aktivasiRekeningBaruVM.namaIbu)
                            }
                            .padding(.top, aktivasiRekeningBaruVM.namaIbu.isEmpty ? 0 : 22)
                            
                            Picker("Kode Pendidikan", selection: $aktivasiRekeningBaruVM.selectedPendidikan) {
                                ForEach(aktivasiRekeningBaruVM.listPendidikan, id: \.self) { item in
                                    if let jenis = item["keterangan"]! as? String {
                                        Text(jenis).tag(jenis)
                                    }
                                }
                            }
                            
                            ZStack(alignment: .leading) {
                                Text("No Telp")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .animation(.linear(duration: 0.3), value: aktivasiRekeningBaruVM.nomorTelp.isEmpty)
                                    .offset(y: aktivasiRekeningBaruVM.nomorTelp.isEmpty ? 0 : -20)
                                TextField("", text: $aktivasiRekeningBaruVM.nomorTelp)
                                    .keyboardType(.numberPad)
                                    .onChange(of: aktivasiRekeningBaruVM.nomorTelp){newValue in
                                        if newValue.count > 13 {
                                            aktivasiRekeningBaruVM.nomorTelp = String(newValue.prefix(13))
                                        }
                                    }
                            }
                            .padding(.top, aktivasiRekeningBaruVM.nomorTelp.isEmpty ? 0 : 22)
                        }
                        
                        
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            
            .blur(radius: aktivasiRekeningBaruVM.isLoading ? 20 : 0)
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
                        Text("AKTIVASI REKENING BARU")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                aktivasiRekeningBaruVM.validateForm()
                            }
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
            .toast(isPresenting: $aktivasiRekeningBaruVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            
            .alert(isPresented: $aktivasiRekeningBaruVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(aktivasiRekeningBaruVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct AktivasiRekeningBaruView_Previews: PreviewProvider {
    static var previews: some View {
        AktivasiRekeningBaruView()
    }
}

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
}

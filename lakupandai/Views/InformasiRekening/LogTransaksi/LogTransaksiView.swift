//
//  LogTransaksiView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI
import MultiDatePicker
import AlertToast
import UIScrollView_InfiniteScroll

struct LogTransaksiView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var logTransaksiVM = LogTransaksiViewModel()
  
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack(alignment: .center) {
                    VStack {
                        Text("Log Transaksi")
                        Button {
                            logTransaksiVM.showRangeDate = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .fill(.white.opacity(0.5))
                                    .frame(width: 300, height: 30)
                                Text("\(formattedDate(logTransaksiVM.dateRange?.lowerBound ?? .now))") + Text("   -   ")
                                    .foregroundColor(.black) + Text("\(formattedDate(logTransaksiVM.dateRange?.upperBound ?? .now))")
                                
                            }
                        }
                        .popover(isPresented: $logTransaksiVM.showRangeDate) {
                            NavigationStack {
                                VStack {
                                    MultiDatePicker(dateRange: $logTransaksiVM.dateRange)
                                    
                                    Button("Close") {
                                        logTransaksiVM.showRangeDate = false
                                    }
                                    .padding()
                                }
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle("Pilih Rentang Tanggal")
                            }
                            .presentationDetents([.fraction(0.5)])
                        }
                        .onChange(of: logTransaksiVM.dateRange) { newValue in
                            if newValue != nil {
                                logTransaksiVM.onChangeDateRange()
                            }
                        }
                    }
                    .padding(.bottom,10)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.7))
                    
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(Array(logTransaksiVM.dataMutasi.enumerated()), id: \.element.id) { index, item in
                                let _ = print("ini index \(index)")
                                let _ = print("ini data mutasi \(logTransaksiVM.dataMutasi.count)")
                                let _ = print("ini page \(logTransaksiVM.page)")
                                let _ = print("ini total pages \(logTransaksiVM.totalPages)")
                                let _ = print("______________")
                                
                                NavigationLink(destination: DetailMutasiView(idNotif: item.idNotif, layanan: item.description)) {
                                    RowLogTransaksi(mutasi: item)
                                        .foregroundColor(.black)
                                }
                                .onAppear {
                                    if item == logTransaksiVM.dataMutasi.last && !logTransaksiVM.isLoadData && logTransaksiVM.page < logTransaksiVM.totalPages && logTransaksiVM.rc == 1 {
                                        let _ = print("ini end gezz")
                                        logTransaksiVM.populateDataMutasi()
                                    }
                                }

//                                if index == logTransaksiVM.dataMutasi.count-1 && !logTransaksiVM.isLoadData && logTransaksiVM.page < logTransaksiVM.totalPages && logTransaksiVM.rc == 1
//                                {
//                                    let _ = print("ini end boss di index ke-\(index)")
//                                    NavigationLink(destination: DetailMutasiView(idNotif: item.idNotif, layanan: item.description)) {
//                                        RowLogTransaksi(mutasi: item)
//                                            .foregroundColor(.black)
//                                    }
//    //                                .onAppear {
//    //                                    logTransaksiVM.populateDataMutasi()
//    //                                }
//
//                                } else {
//                                    NavigationLink(destination: DetailMutasiView(idNotif: item.idNotif, layanan: item.description)) {
//                                        RowLogTransaksi(mutasi: item)
//                                            .foregroundColor(.black)
//                                    }
//                                }
                                
                            }
                        }
                        
                    }
                    
                    
                    Spacer()
                }
            }
            
            .toast(isPresenting: $logTransaksiVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $logTransaksiVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(logTransaksiVM.alertMessage),
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
                        Image("ic_logo_diy_white")
                            .resizable()
                            .frame(width: 150, height: 35)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        if logTransaksiVM.isLoadData {
                            Spinner()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
            }
            .toolbarBackground(Color("colorPrimary"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
}

struct LogTransaksiView_Previews: PreviewProvider {
    static var previews: some View {
        LogTransaksiView()
    }
}

private func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    //        dateFormatter.dateStyle = .short
    dateFormatter.dateFormat = "dd-MM-yyyy"
    //        dateFormatter.timeStyle = .short
    return dateFormatter.string(from: date)
}

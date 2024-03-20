//
//  BluetoothView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 08/02/24.
//

import SwiftUI
import Printer

struct BluetoothView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text("Perangkat yang tersedia")
                        .padding(.horizontal)
                    List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
                        Button(action: {
//                            print(bl)
                        }) {
                            Text(peripheral)
                        }
                    }
                    .refreshable {
                        print("Do your refresh work here")
                    }
                    .scrollContentBackground(.hidden)
                    Spacer()
                }
            }
            .navigationTitle("Perangkat Bluetooth")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView()
    }
}

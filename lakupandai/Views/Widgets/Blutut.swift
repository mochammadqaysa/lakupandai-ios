//
//  Blutut.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 13/02/24.
//

import SwiftUI
import Printer

struct Blutut: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State private var isPrinting = false
    var body: some View {
        VStack {
            Text("Scanning")
            List(Array(bluetoothManager.discoveredPeripherals.values), id: \.identifier) { peripheral in
                Button(action: {
                    self.bluetoothManager.selectedPeripheral = peripheral
                    self.printReceipt()
                }) {
                    Text(peripheral.name ?? "Unknown")
                }
            }
            .onAppear {
                self.bluetoothManager.centralManager.delegate = self.bluetoothManager
            }

            Spacer()

            if isPrinting {
                ProgressView()
                    .padding()
            }
        }
    }
    
    func printReceipt() {
            guard let peripheral = bluetoothManager.selectedPeripheral else {
                print("No selected peripheral")
                return
            }
        for i in 0..<peripheral.services!.count {
            print("asd ini servis ke \(i) : \(peripheral.services![i])")
            
        }
        print("asd ini service \(peripheral.services?.first?.characteristics)")

//            guard let service = peripheral.services?.first(where: { $0.uuid.uuidString == "05330966-B36C-8F8A-A2D8-EB5ED9650152" }) else {
            guard let service = peripheral.services?.first(where: { $0.uuid.uuidString == "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2" }) else {
                print("Printer service not found")
                return
            }
        print("asd ini characteristics selected :  \(service.characteristics)")

            guard let characteristic = service.characteristics?.first(where: { $0.uuid.uuidString == "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2" }) else {
                print("Printer characteristic not found")
                return
            }

            let receiptData = "This is your receipt text".data(using: .utf8)!

            peripheral.writeValue(receiptData, for: characteristic, type: .withResponse)
            isPrinting = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.isPrinting = false
            }
        }
}

struct Blutut_Previews: PreviewProvider {
    static var previews: some View {
        Blutut()
    }
}

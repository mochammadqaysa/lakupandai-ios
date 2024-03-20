//
//  BluetoothManager.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 13/02/24.
//

import Foundation
import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var centralManager: CBCentralManager!
    @Published var discoveredPeripherals: [String: CBPeripheral] = [:]
    @Published var selectedPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: [CBUUID(string: "00001101-0000-1000-8000-00805F9B34FB")], options: nil)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let peripheralName = peripheral.name ?? "Unknown"
        print("Discovered peripheral: \(peripheralName), \(peripheral.identifier)")
        discoveredPeripherals[peripheral.identifier.uuidString] = peripheral

        if peripheralName.lowercased().contains("printer") {
            selectedPeripheral = peripheral
            centralManager.stopScan()
            central.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown"), \(peripheral.identifier)")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

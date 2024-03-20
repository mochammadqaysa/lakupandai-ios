//
//  lakupandaiApp.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 04/10/23.
//

import SwiftUI
import UserNotifications


@main
struct lakupandaiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            StartView()
//            BluetoothView()
//            Blutut()
                .preferredColorScheme(.light)
                .onAppear{
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
        }
    }
}

//
//  UserDefaultsManager.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/12/23.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    // MARK: - Save data to UserDefaults
    
    func saveString(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: - Retrieve data from UserDefaults
    
    func getString(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func deleteKey(forKey key : String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

//
//  ItemValue.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 07/12/23.
//

import Foundation

struct ItemValue: Identifiable {
    var id = UUID()
    var header: String
    var value: String
    
    init(id: UUID = UUID(), header: String, value: String) {
        self.id = id
        self.header = header
        self.value = value
    }
    
    init?(jsonDictionary: [String: String]) {
        guard let header = jsonDictionary["header"],
              let value = jsonDictionary["value"]
        else {
            return nil
        }

        self.init(header: header, value: value)
    }
}

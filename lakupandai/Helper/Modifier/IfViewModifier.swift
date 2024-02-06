//
//  IfViewModifier.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import Foundation
import SwiftUI

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
         if conditional {
             return AnyView(content(self))
         } else {
             return AnyView(self)
         }
     }
}


//
//  SingleMenu.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 05/10/23.
//

import SwiftUI

struct SingleMenu: View {
    var sourceImage : String
    var title : String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)
                .shadow(radius: 3)
            
            VStack {
                Image("\(sourceImage)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                Text("\(title)")
                    .font(.caption)
            }
            .multilineTextAlignment(.center)
        }
        .frame(width: 105, height: 105)
    }
}

struct SingleMenu_Previews: PreviewProvider {
    static var previews: some View {
        SingleMenu(sourceImage: "ic_buka_rekening_baru", title: "Aktivasi Rekening Baru")
    }
}

//
//  PetView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/30/24.
//

import SwiftUI

struct PetView: View {
    
    @State var catIsOn: Bool = true
    

    var body: some View {
        if catIsOn {
            CatView(catIsON: $catIsOn)
        }else {
            DogView(catIsON: $catIsOn)
        }

    }
}

#Preview {
    PetView()
}

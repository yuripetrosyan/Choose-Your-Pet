//
//  PetView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/30/24.
//

import SwiftUI

struct PetView: View {
    
    @State var catIsOn: Bool = true
    @StateObject var dogViewModel = DogViewModel()


    var body: some View {
        if catIsOn {
            CatView(catIsON: $catIsOn)
        }else {
            DogView(viewModel: DogViewModel(), catIsON: $catIsOn)
        }

    }
}

#Preview {
    PetView()
}

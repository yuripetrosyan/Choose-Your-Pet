//
//  VersionMenu.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/26/24.
//

import SwiftUI
import Lottie

struct VersionMenu: View {
    //change to binding later
    @Binding var catIsON: Bool
    
    var body: some View {
        ZStack{
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 40, height: 40)
            VStack{
                
                LottieView(animation: .named(catIsON ? "catVersion.json" : "dogVersion.json"))
                    .playing()
            }
            .offset(y: catIsON ? -25 : 0)
            .frame(width: 70, height: 70)
                
                
        }
        
        .onTapGesture {
            catIsON.toggle()
        }
    }
}

#Preview {
    VersionMenu(catIsON: .constant(true))
}

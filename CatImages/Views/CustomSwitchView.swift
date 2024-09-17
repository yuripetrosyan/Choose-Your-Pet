//
//  CustomSwitchView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/17/24.
//

import SwiftUI

struct CustomSwitchView: View {
    
    @Binding var favIsON: Bool
    
    var body: some View {
        
        ZStack{
            Capsule()
                //.fill(.ultraThinMaterial)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 40)
                .overlay {
                    HStack{
                        Image(systemName: "flame.fill")
                            
                            //.foregroundStyle(.orange)
                        Spacer()
                        Image(systemName: "heart.fill")
                        
                            //.foregroundStyle(.red)
                            
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)){
                            favIsON.toggle()
                        }
                    }
                    .padding(.horizontal)
                }
           
                
            Capsule()
                .frame(width: 50, height: 40)
                .foregroundStyle(.white)
                .shadow(radius: 2)
                .overlay(content: {
                    Image(systemName: favIsON ? "heart.fill" : "flame.fill")
                        .foregroundStyle(favIsON ? .red : .orange)
                       

                })
            
                .offset(x: favIsON ? 25 : -25)

                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.4)){
                        favIsON.toggle()
                    }
                }
            
            
        }
        

    }
    
}

#Preview {
    CustomSwitchView(favIsON: .constant(true))
}

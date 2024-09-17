//
//  Controllers.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/17/24.
//

import SwiftUI

struct ControllersView: View {
    var onDislike: () -> Void
    //var onGoBack: () -> Void
    var onLike: () -> Void
    var onDetails: () -> Void
    var infoON: () -> Void
    
    var body: some View {
        HStack(spacing: 15){
            
            CustomButton(imageName: "chevron.left", backgroundWidth: 50, foregroundSize: 20, color: .blue)
                .onTapGesture {
                   // onGoBack()
                }
            
            CustomButton(imageName: "xmark", backgroundWidth: 80, foregroundSize: 30, color: .red)
                .fontWeight(.bold)
                .onTapGesture {
                    onDislike()
                }
            
            CustomButton(imageName: "book.fill", backgroundWidth: 60, foregroundSize: 25, color: .yellow)
                .onTapGesture {
                    onDetails()
                }
            
            CustomButton(imageName: "heart.fill", backgroundWidth: 80, foregroundSize: 30, color: .green)
                .fontWeight(.bold)
                .onTapGesture {
                    onLike()
                }
            
            CustomButton(imageName: "info", backgroundWidth: 30, foregroundSize: 15, color: .gray)
                .onTapGesture {
                    infoON()
                }
            
            
        }
        
        
    }
    
}

struct CustomButton: View {
    var imageName: String
    var backgroundWidth: CGFloat
    var foregroundSize: CGFloat
    var color: Color
    
    
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 2)
                .foregroundStyle(color)
                .frame(width: backgroundWidth, height: backgroundWidth)
                .shadow(color: color, radius: 5)
            
            
            Image(systemName: imageName)
                .font(.system(size: foregroundSize))
                .foregroundStyle(color)
            
            
        }
    }
}

//#Preview {
//    ControllersView()
//}

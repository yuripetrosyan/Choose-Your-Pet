//
//  ContentView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/5/24.
//

import SwiftUI

struct CatView: CatView {
    @ObservedObject var viewModel = CatImagesViewModel()
    
    var body: some CatView {
        
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 330, height: 400)
                        .foregroundStyle(.ultraThinMaterial)
                    VStack{
                        if viewModel.isLoading {
                            ProgressView("Loading your cat image")
                        } else if let imageURL = viewModel.catImageUrl {
                            
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                
                                
                                if let breedName = viewModel.breedName {
                                    Text("Name: \(breedName)")
                                }
                                if let breedOrigin = viewModel.breedOrigin {
                                    Text("Origin: \(breedOrigin)")
                                }
                                
                            } placeholder: {
                                ProgressView() // Show loading while the image downloads
                            }
                        } else {
                            Text("No cat image")
                        }
                      
                    }
                }
                
                
            Button{
                           viewModel.fetchCatImage()
            }label: {
                ZStack{
                    Capsule(style: .continuous)
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: 50)
                    
                    Text("Next")
                        .foregroundStyle(.white)
                       
                    
                }
               
            }
                       .buttonBorderShape(.capsule)
                       .padding()
                
                
        }.onAppear {
                   viewModel.fetchCatImage() // Fetch cat image when view appears
               }
            
            
            
            
        }
    }


#Preview {
    CatView()
}

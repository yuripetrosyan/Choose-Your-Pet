//
//  ContentView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/5/24.
//

import SwiftUI

struct CatView: View {
    @ObservedObject var viewModel = CatImagesViewModel()
    @State private var detailedON: Bool = false
    @State private var dragOffset: CGFloat = 0.0 // Used to track the swipe gesture
    @State private var verticalDragOffset: CGFloat = 0.0
    
    var body: some View {
        
        VStack{
            ZStack(alignment: .bottom){
                if viewModel.isLoading {
                    ProgressView("Loading your next cat image")
                } else if let imageURL = viewModel.catImageUrl {
                    
                    AsyncImage(url: URL(string: imageURL)) { image in
                        ZStack{
                            image
                                .resizable()
                                .frame(width: 330, height: 430)
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                            
                            
                            
                            
                            // MARK: Info Capsule
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                
                                    .foregroundStyle(.ultraThinMaterial)
                                
                                infoView
                                
                            }
                            .frame(width: detailedON ? 330 : 310, height: detailedON ? 430 : 80 - verticalDragOffset)
                            .offset(y: detailedON ? 0 : 165 + verticalDragOffset)
                                                            .onTapGesture {
                                                                withAnimation(.easeInOut(duration: 0.3)){
                                                                    detailedON.toggle()
                                                                }
                                                            }
                            
                            .gesture(
                                
                                //Swipe Up Info capsule
                                DragGesture()
                                    .onChanged { value in
                                        // Only allow upward dragging
                                        if value.translation.height < 0 {
                                            verticalDragOffset = value.translation.height
                                        }
                                    }
                                    .onEnded { value in
                                        // If dragged upwards enough, open the capsule
                                        if value.translation.height < -80 {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                detailedON = true
                                            }
                                        }
                                        // Reset drag offset
                                        verticalDragOffset = 0
                                    }
                                //Swipe Down Info capsule
                                
                            )
                        }
                        
                        
                    }
                
                
                placeholder: {
                    ProgressView() // Show loading while the image downloads
                }
            } else {
                Text("No cat image")
            }
            
        }
        .offset(x: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width // Track the swipe movement
                }
                .onEnded { value in
                    if value.translation.width < -80 { // Swipe left to load next image
                        viewModel.fetchCatImage()
                    }
                    withAnimation(.spring()) {
                        dragOffset = 0 // Reset offset after swipe
                        
                        
                        
                    }
                }
        )
        
        
        //            Button{
        //                           viewModel.fetchCatImage()
        //            }label: {
        //                ZStack{
        //                    Capsule(style: .continuous)
        //                        .foregroundStyle(.blue)
        //                        .frame(width: 120, height: 50)
        //
        //                    Text("Next")
        //                        .foregroundStyle(.white)
        //
        //
        //                }
        
        //            }
        //                       .buttonBorderShape(.capsule)
        //                       .padding()
        
        
    }.onAppear {
        viewModel.fetchCatImage() // Fetch cat image when view appears
    }
    
    
    
    
}

    var infoView: some View {
        VStack(spacing: 0){
            
            if !detailedON {
                Image(systemName: "chevron.compact.up")
                    .offset(y:  verticalDragOffset/2 - 5)
            }else{
                
                Image(systemName: "minus")
                Spacer()
            }
           
               
            
              
            
            
            VStack(alignment: .leading){
                if let breedName = viewModel.breedName {
                    Text("**Name:**  \(breedName)")
                }
                if let breedOrigin = viewModel.breedOrigin {
                    Text("**Origin:**  \(breedOrigin)")
                }
                
                if detailedON {
                    //                if let breedDescription = viewModel.breedOrigin {
                    //                    Text("**Description:**  \(breedDescription)")
                    //                }
                    if let breedTemperament = viewModel.breedTemperament {
                        VStack{
                            Text("**Temperament:**  \(breedTemperament)")
                        }
                    }
                    if let breedLifeSpan = viewModel.breedLifespan {
                        VStack{
                            Text("**Life Span:**  \(breedLifeSpan)")
                        }
                    }
                    if let breedDescription = viewModel.breedDescription {
                        HStack{
                            Text("**Description:**  \(breedDescription)")
                        }
                    }
                    if let dog_friendly = viewModel.dog_friendly {
                        VStack{
                            Text("**Dog Friendly:**  \(dog_friendly)")
                        }
                    }
                }
                
            }.padding(.horizontal)
        }
           
            .frame( height: detailedON ? 420 : 30)
        }
    
}


#Preview {
    CatView()
}

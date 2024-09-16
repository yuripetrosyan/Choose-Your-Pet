//
//  ContentView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/5/24.
//

import SwiftUI
import Lottie

struct CatView: View {
    @ObservedObject var viewModel = CatImagesViewModel()
    @State private var detailedON: Bool = false
    @State private var dragOffset: CGFloat = 0.0 // Used to track the swipe gesture
    @State private var verticalDragOffset: CGFloat = 0.0
    
    @State private var isLiked: Bool = false
    @State private var isDisliked: Bool = false
    @State private var showAlert = false
    
    var body: some View {
        
        NavigationStack {
            VStack{
                
                ZStack{
                    
                    ZStack(alignment: .bottom){
                        if viewModel.isLoading {
                            LottieView(animation: .named("cat1.json"))
                                .playing()
                                .frame(width: 200, height: 200)
                            
                            
                            
                            
                        } else if let imageURL = viewModel.catImageUrl {
                            
                            AsyncImage(url: URL(string: imageURL)) { image in
                                
                                ZStack{
                                     image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 330, height: 430)
                                    //.scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 40))
                                    
                                    
                                    
                                    
                                    // MARK: Info Capsule
                                    ZStack{
                                        
                                        
                                        RoundedRectangle(cornerRadius: 30)
                                        
                                            .foregroundStyle(.ultraThinMaterial)
                                        
                                        infoView
                                        
                                        
                                        
                                    }
                                    .frame(width: detailedON ? 330 : 310, height: detailedON ? (430 - abs(verticalDragOffset)) : 80 - verticalDragOffset)
                                    .offset(y: detailedON ? 0 : 165 + verticalDragOffset)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)){
                                            detailedON.toggle()
                                        }
                                    }
                                    
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                // Handle both upward and downward dragging
                                                if value.translation.height < 0 {
                                                    verticalDragOffset = value.translation.height // Dragging up
                                                } else if value.translation.height > 0 && detailedON {
                                                    verticalDragOffset = value.translation.height // Dragging down
                                                }
                                            }
                                            .onEnded { value in
                                                // Swipe up to open the capsule
                                                if value.translation.height < -80 {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        detailedON = true
                                                    }
                                                }
                                                // Swipe down to close the capsule
                                                if value.translation.height > 80 && detailedON {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        detailedON = false
                                                    }
                                                }
                                                // Reset drag offset
                                                verticalDragOffset = 0
                                            }
                                    )
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            placeholder: {
                                LottieView(animation: .named("cat1.json"))
                                    .playing()
                                    .frame(width: 200, height: 200)
                                // Show loading while the image downloads
                                
                                
                            }
                            
                        } else {
                           // Text("No cat image")
                        }
                        
                        
                        
                    }
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width * 1.7 // Track the swipe movement
                            }
                            .onEnded { value in
                                if value.translation.width < -80 { // Swipe left to load next image
                                    isDisliked = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        isDisliked = false
                                        
                                        viewModel.fetchCatImage()
                                    }
                                } else if value.translation.width > 80 {
                                    
                                    isLiked = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        isLiked = false
                                        //action here
                                        likeCurrentCat()
                                        viewModel.fetchCatImage()
                                    }
                                    
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                    withAnimation(.spring()) {
                                        dragOffset = 0 // Reset offset after swipe
                                    }
                                }
                            }
                    )
                    
                    
                    
                    //Animation when Liked
                    if isLiked {
                        LottieView(animation: .named("heart.json"))
                            .playing()
                            .frame(width: 300, height: 300)
                            .offset(x: dragOffset / 4)
                    }
                    //Animation when disliked
                    else if isDisliked {
                        LottieView(animation: .named("xmark.json"))
                            .playing()
                            .opacity(0.8)
                            .frame(width: 100, height: 100)
                            .offset(x: dragOffset / 4)

                        
                    }
                    
                }
//                  
                    
                
                
            }.onAppear {
                viewModel.fetchCatImage() // Fetch cat image when view appears
            }
            .alert(isPresented: $showAlert) { // Show the alert when showAlert is true
                Alert(
                    title: Text("Information"),
                    message: Text("Swipe up to see more details, left to load next image or right to add the cat to your favorites"),
                    dismissButton: .default(Text("Close"))
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){                // Add navigation button to view favorites
                    NavigationLink(destination: FavoritesView(viewModel: viewModel)){
                    //NavigationLink(destination: FavoritesView()){
                        Image(systemName: "star.fill")
                           // .font(.title4)
                           // .background(Circle().foregroundStyle(.ultraThinMaterial)
                                //.frame(width: 40, height: 40))
                            .foregroundColor(.yellow)
                        
                    }
                    
                }
                
                ToolbarItem(placement: .topBarLeading){
                    //Info button
                    Button {
                        showAlert = true
                        
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.white)
                    }
              


                    
                }
            }
        }
        
        
        
        
        
    }
    
    var infoView: some View {
        VStack(spacing: 0){
            
            if !detailedON {
                Image(systemName: "chevron.compact.up")
                    .offset(y:  verticalDragOffset/2 - 5)
            }else{
                
                Image(systemName: "minus")
                    .padding(.bottom, 20)
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
        
       // .frame( height: detailedON ? 420 : 30)
    }
    
    func likeCurrentCat() {
        if let url = viewModel.catImageUrl,
           let breedName = viewModel.breedName,
           let breedOrigin = viewModel.breedOrigin,
           let breedDescription = viewModel.breedDescription,
           let breedTemperament = viewModel.breedTemperament,
           let breedLifespan = viewModel.breedLifespan,
           let dogFriendly = viewModel.dog_friendly {

            let currentCat = CatImage(
                url: url,
                breeds: [Breed(
                    name: breedName,
                    origin: breedOrigin,
                    description: breedDescription,
                    temperament: breedTemperament,
                    life_span: breedLifespan,
                    dog_friendly: dogFriendly
                )]
            )
            viewModel.likeCat(cat: currentCat)
        }
    }
    
}


#Preview {
    CatView()
}

//
//  DogView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/30/24.
//



import SwiftUI
import Lottie

struct DogView: View {
    
    @ObservedObject var viewModel: DogViewModel
    @State private var detailedON: Bool = false
    @State private var dragOffset: CGFloat = 0.0 // Used to track the swipe gesture
    @State private var verticalDragOffset: CGFloat = 0.0
    @State private var isLiked: Bool = false
    @State private var isDisliked: Bool = false
    @State private var showAlert = false
    
    @State var favIsON: Bool = false
    @Binding var catIsON: Bool 
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack{
                    VStack{
                        ZStack{
                            ZStack(alignment: .bottom){
                                if viewModel.isLoading {
                                    LottieView(animation: .named("dogVersion.json"))
                                        .playing()
                                        //.frame(width: 200, height: 200)
                                        //.background(Rectangle())
                                        .frame(width: geo.size.width * 0.95, height: geo.size.width * 1.4)
                                        .offset(y: geo.size.height / 4)
                                } else if let imageURL = viewModel.imageUrl {
                                    //Cat card
                                    AsyncImage(url: URL(string: imageURL)) { image in
                                        ZStack(alignment: .bottom){
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geo.size.width * 0.95, height: geo.size.width * 1.4)
                                                .clipShape(RoundedRectangle(cornerRadius: 40))
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .foregroundStyle(.ultraThinMaterial)
                                                
                                                infoView
                                            }
                                            .frame(width: detailedON ? geo.size.width * 0.95 : geo.size.width * 0.9, height: detailedON ? (geo.size.width * 1.4 - abs(verticalDragOffset)) : geo.size.width * 0.2 - verticalDragOffset)
                                            .padding(.bottom, detailedON ? 0 : 10)
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.3)){
                                                    detailedON.toggle()
                                                }
                                            }
                                            .gesture(
                                                DragGesture()
                                                    .onChanged { value in
                                                        if value.translation.height < 0 {
                                                            verticalDragOffset = value.translation.height
                                                        } else if value.translation.height > 0 && detailedON {
                                                            verticalDragOffset = value.translation.height
                                                        }
                                                    }
                                                    .onEnded { value in
                                                        if value.translation.height < -80 {
                                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                                detailedON = true
                                                            }
                                                        }
                                                        if value.translation.height > 80 && detailedON {
                                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                                detailedON = false
                                                            }
                                                        }
                                                        verticalDragOffset = 0
                                                    }
                                            )
                                        }.padding(.top)
                                    }
                                    placeholder: {
                                        LottieView(animation: .named("dogVersion.json"))
                                            .playing()
                                           // .frame(width: 200, height: 200)
                                            .frame(width: geo.size.width * 0.95, height: geo.size.width * 1.4)
                                        
                                            .offset(y: geo.size.height / 4)
                                    }
                                }
                            }
                            .offset(x: dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation.width * 1.7
                                    }
                                    .onEnded { value in
                                        if value.translation.width < -80 {
                                            isDisliked = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                isDisliked = false
                                                viewModel.fetchDogImage()
                                            }
                                        } else if value.translation.width > 80 {
                                            isLiked = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                isLiked = false
                                                likeCurrentDog()
                                                viewModel.fetchDogImage()
                                            }
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                            withAnimation(.spring()) {
                                                dragOffset = 0
                                            }
                                        }
                                    }
                            )
                            
                            if isLiked {
                                LottieView(animation: .named("heart.json"))
                                    .playing()
                                    .frame(width: 300, height: 300)
                                    .offset(x: dragOffset / 4)
                            }
                            else if isDisliked {
                                LottieView(animation: .named("xmark.json"))
                                    .playing()
                                    .opacity(0.8)
                                    .frame(width: 100, height: 100)
                                    .offset(x: dragOffset / 4)
                            }
                        }
                        
                        // Integrating Custom Buttons (like Tinder) here
                        ControllersView(onDislike: {
                            isDisliked = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isDisliked = false
                                viewModel.fetchDogImage()
                            }
                        },onLike: {
                            isLiked = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isLiked = false
                                likeCurrentDog()
                                viewModel.fetchDogImage()
                            }
                        }, onDetails: {withAnimation(.easeInOut) {
                            detailedON.toggle()
                        } }, infoON: {showAlert.toggle()})
                        .padding(.bottom, 30)
                        
                        Spacer()
                    }
                    .onAppear {
                        viewModel.fetchDogImage()
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Information"),
                            message: Text("Swipe up to see more details, left to load next image, or right to add the cat to your favorites"),
                            dismissButton: .default(Text("Close"))
                        )
                    }
                    //MARK: Toolbar
                    .toolbar {
                        
                        ToolbarItem(placement: .navigation) {
                            VersionMenu(catIsON: $catIsON)
                            //
                               
                        }
                        ToolbarItem(placement: .navigation) {
                            HStack{
                                Spacer()
                                CustomSwitchView(favIsON: $favIsON)
                                    .padding(.leading, -65)
                                Spacer()
                            }
                            .frame(width: geo.size.width )
                        }
                    }
                    if favIsON {
                        DogFavoritesView(dogViewModel: viewModel, catIsOn: $catIsON)
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
            } else {
                Image(systemName: "minus")
                    .padding(.bottom, 20)
            }
            
            VStack(alignment: .leading){
                if let breedName = viewModel.breedName {
                    Text("**Name:**  \(breedName)")
                }
                if let breedLifeSpan = viewModel.breedLifespan {
                    VStack {
                        Text("**Life Span:**  \(breedLifeSpan)")
                    }
                }
                
                if detailedON {
                    if let breedTemperament = viewModel.breedTemperament {
                        VStack {
                            Text("**Temperament:**  \(breedTemperament)")
                        }
                    }
                   

                }
            }.padding(.horizontal)
        }
    }
    
    func likeCurrentDog() {
        if let url = viewModel.imageUrl,
           let breedName = viewModel.breedName,
           let breedOrigin = viewModel.breedOrigin,
           //let breedDescription = viewModel.breedDescription,
           let breedTemperament = viewModel.breedTemperament,
           let breedLifespan = viewModel.breedLifespan
           //let dogFriendly = viewModel.dog_friendly
        {
            
            let currentDog =
            DogImage(url: url, breeds: [DogBreed(name: breedName, origin: breedOrigin, temperament: breedTemperament, life_span: breedLifespan)])
            
        
            viewModel.likeDog(dog: currentDog)
        }
    }
}




#Preview {
    DogView(viewModel: DogViewModel(), catIsON: .constant(false))
}

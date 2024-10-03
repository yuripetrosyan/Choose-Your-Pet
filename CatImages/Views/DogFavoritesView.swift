//
//  FavoritesView.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/15/24.
//

import SwiftUI

struct DogFavoritesView: View {
    @ObservedObject var dogViewModel: DogViewModel
    @Binding var catIsOn: Bool
    
  

    let columns = [GridItem(.flexible()), GridItem(.flexible())] // Two columns
    //@State private var favIsOn = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(dogViewModel.favoriteDogs, id: \.url) { dog in
                        DogCardView(dog: dog)
                            .contextMenu {
                                Button(role: .destructive) {
                                    dogViewModel.deleteDog(dog: dog)
                                } label: {
                                    Text("Delete")
                                }
                            }
                    }
                }
                
                .padding()
            }
            .navigationTitle("Favorite Dogs")
//        }.toolbar {
//            ToolbarItem(placement: .navigation) {
//                CustomSwitchView(favIsON: $favIsOn)
//            }
        }
    }
}



struct DogCardView: View {
    let dog: DogImage

    @State private var detailedON: Bool = false
    @State private var verticalDragOffset: CGFloat = 0.0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: dog.url)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                ProgressView()
                    .frame(width: 160, height: 220)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.2)))
            }

            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(height: detailedON ? 220 : 60) // Change height when detailed is on
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(dog.breeds?.first?.name ?? "Unknown Breed")
                        .font(.headline)
                    if detailedON {
                       
                        Text("Temperament: \(dog.breeds?.first?.temperament ?? "Unknown Temperament")")
                            .font(.subheadline)
                        Text("Life Span: \(dog.breeds?.first?.life_span ?? "Unknown")")
                            .font(.subheadline)
                        
                    }
                }
                .padding(.horizontal)
            }
          
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    detailedON.toggle()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height < 0 { // Only allow upward dragging
                            verticalDragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height < -50 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                detailedON = true
                            }
                        } else if value.translation.height > 50 && detailedON {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                detailedON = false
                            }
                        }
                        verticalDragOffset = 0
                    }
            )
        }
        .frame(width: 160, height: 220) // Size for each card in the grid
    }
}


#Preview {
    DogFavoritesView(dogViewModel: DogViewModel(), catIsOn: .constant(false))
   
}



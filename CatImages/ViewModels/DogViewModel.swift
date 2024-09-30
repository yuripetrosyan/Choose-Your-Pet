//
//  DogViewModel.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/30/24.
//

import Foundation
import Observation

class DogViewModel: ObservableObject {
    
    
     @Published var imageUrl: String?
     @Published var breedName: String?
     @Published var breedOrigin: String?
     //@Published var breedDescription: String?
     @Published var breedLifespan: String?
     @Published var breedTemperament: String?
    // @Published var dog_friendly: Int?
     @Published var isLoading: Bool = false
    @Published var favoriteDogs: [DogImage] = []
    
    // Function to like a dog
    func likeDog (dog: DogImage) {
        if !favoriteDogs.contains(where: { $0.url == dog.url }) {
            favoriteDogs.append(dog)
        }
    }
    
    // Function to Delete a cat from favouriste
    func deleteCat(cat: CatImage) {
        favoriteDogs.removeAll(where: { $0.url == cat.url })
    }
    
    func fetchDogImage() {
        isLoading = true
        let urlString = "https://api.thedogapi.com/v1/images/search"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue("live_ZKsRNbBoSEYNnzpTj6uDviNvZVttx0rHo3zNVr5VN8hkZegxwFJxxNDk2cU6YNge", forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Ensure the response happens in the main thread
            DispatchQueue.main.async {
                self?.isLoading = false
            }

            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let dogImages = try JSONDecoder().decode([DogImage].self, from: data)
                
                // Ensure any UI-related changes happen on the main thread
                DispatchQueue.main.async {
                    if let dogImageWithBreed = dogImages.first {
                        self?.imageUrl = dogImageWithBreed.url
                        if let breed = dogImageWithBreed.breeds?.first {
                            self?.breedName = breed.name ?? "Unknown"
                            self?.breedOrigin = breed.origin ?? "Unknown"
                            self?.breedTemperament = breed.temperament ?? "Unknown"
                            self?.breedLifespan = breed.life_span ?? "Unknown"
                        }
                    } else {
                        self?.fetchDogImage()
                    }
                }            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
    
}

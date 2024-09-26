//
//  ViewModel.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/5/24.
//
import Foundation
import Observation

class CatImagesViewModel: ObservableObject {
    @Published var catImageUrl: String?
    @Published var breedName: String?
    @Published var breedOrigin: String?
    @Published var breedDescription: String?
    @Published var breedLifespan: String?
    @Published var breedTemperament: String?
    @Published var dog_friendly: Int?
    @Published var isLoading: Bool = false
    
    // Array to store favorite cats
    @Published var favoriteCats: [CatImage] = []
    
    // Function to like a cat
    func likeCat(cat: CatImage) {
        if !favoriteCats.contains(where: { $0.url == cat.url }) {
            favoriteCats.append(cat)
        }
    }
    
    // Function to Delete a cat from favouriste
    func deleteCat(cat: CatImage) {
        favoriteCats.removeAll(where: { $0.url == cat.url })
    }
    
    func fetchCatImage() {
        isLoading = true
        let urlString = "https://api.thecatapi.com/v1/images/search"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue("live_NSDLtNjewVb0C7sBsD0iof30AFWZxIAEm2o11QoAhN68m16pDAIu8iCEwnvk3zeC", forHTTPHeaderField: "x-api-key")
        
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
                let catImages = try JSONDecoder().decode([CatImage].self, from: data)
                
                // Ensure any UI-related changes happen on the main thread
                DispatchQueue.main.async {
                    // Find the first cat image that has breed information
                    if let catImageWithBreed = catImages.first(where: { !$0.breeds.isEmpty }) {
                        self?.catImageUrl = catImageWithBreed.url
                        if let breed = catImageWithBreed.breeds.first {
                            self?.breedName = breed.name
                            self?.breedOrigin = breed.origin
                            self?.breedTemperament = breed.temperament
                            self?.breedLifespan = breed.life_span
                            self?.dog_friendly = breed.dog_friendly
                            self?.breedDescription = breed.description
                        }
                    } else {
                        // Retry fetching if no breed info
                        self?.fetchCatImage()
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }        }


 //Mock data for testing purposes
extension CatImagesViewModel {
    static let mockData: [CatImage] = [
        CatImage(
            url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg",
            breeds: [
                Breed(
                    name: "Abyssinian",
                    origin: "Egypt",
                    description: "A short-haired breed of domestic cat.",
                    temperament: "Active, Energetic, Independent, Intelligent, Gentle",
                    life_span: "14 - 15",
                    dog_friendly: 5
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg",
            breeds: [
                Breed(
                    name: "Siberian",
                    origin: "Russia",
                    description: "A large, strong cat with a dense triple coat.",
                    temperament: "Curious, Calm, Affectionate, Intelligent",
                    life_span: "12 - 15",
                    dog_friendly: 4
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/MTY3ODQ4OQ.jpg",
            breeds: [
                Breed(
                    name: "Bengal",
                    origin: "United States",
                    description: "A wild-looking, sleek, and agile breed.",
                    temperament: "Alert, Agile, Energetic, Demanding, Intelligent",
                    life_span: "10 - 16",
                    dog_friendly: 3
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg",
            breeds: [
                Breed(
                    name: "Abyssinian",
                    origin: "Egypt",
                    description: "A short-haired breed of domestic cat.",
                    temperament: "Active, Energetic, Independent, Intelligent, Gentle",
                    life_span: "14 - 15",
                    dog_friendly: 5
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg",
            breeds: [
                Breed(
                    name: "Siberian",
                    origin: "Russia",
                    description: "A large, strong cat with a dense triple coat.",
                    temperament: "Curious, Calm, Affectionate, Intelligent",
                    life_span: "12 - 15",
                    dog_friendly: 4
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/MTY3ODQ4OQ.jpg",
            breeds: [
                Breed(
                    name: "Bengal",
                    origin: "United States",
                    description: "A wild-looking, sleek, and agile breed.",
                    temperament: "Alert, Agile, Energetic, Demanding, Intelligent",
                    life_span: "10 - 16",
                    dog_friendly: 3
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg",
            breeds: [
                Breed(
                    name: "Abyssinian",
                    origin: "Egypt",
                    description: "A short-haired breed of domestic cat.",
                    temperament: "Active, Energetic, Independent, Intelligent, Gentle",
                    life_span: "14 - 15",
                    dog_friendly: 5
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg",
            breeds: [
                Breed(
                    name: "Siberian",
                    origin: "Russia",
                    description: "A large, strong cat with a dense triple coat.",
                    temperament: "Curious, Calm, Affectionate, Intelligent",
                    life_span: "12 - 15",
                    dog_friendly: 4
                )
            ]
        ),
        CatImage(
            url: "https://cdn2.thecatapi.com/images/MTY3ODQ4OQ.jpg",
            breeds: [
                Breed(
                    name: "Bengal",
                    origin: "United States",
                    description: "A wild-looking, sleek, and agile breed.",
                    temperament: "Alert, Agile, Energetic, Demanding, Intelligent",
                    life_span: "10 - 16",
                    dog_friendly: 3
                )
            ]
        )
    ]
}

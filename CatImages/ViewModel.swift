//
//  ViewModel.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/5/24.
//
import Foundation

class CatImagesViewModel: ObservableObject {
    
    @Published var catImageUrl: String?
    @Published var breedName: String?
    @Published var breedOrigin: String?
    @Published var breedDescription: String?
    @Published var breedLifespan: String?
    @Published var breedTemperament: String?
    @Published var dog_friendly: Int?
    @Published var isLoading: Bool = false
    
    func fetchCatImage() {
        isLoading = true
        let urlString = "https://api.thecatapi.com/v1/images/search"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("live_NSDLtNjewVb0C7sBsD0iof30AFWZxIAEm2o11QoAhN68m16pDAIu8iCEwnvk3zeC", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                        
                        // Find the first cat image that has breed information
                        if let catImageWithBreed = catImages.first(where: { !$0.breeds.isEmpty }) {
                            DispatchQueue.main.async {
                                self?.catImageUrl = catImageWithBreed.url
                                if let breed = catImageWithBreed.breeds.first {
                                    self?.breedName = breed.name
                                    self?.breedOrigin = breed.origin
                                    self?.breedTemperament = breed.temperament
                                    self?.breedLifespan = breed.life_span
                                    self?.dog_friendly = breed.dog_friendly
                                    self?.breedDescription = breed.description
                                }
                            }
                        } else {
                            print("No breed information available for this cat image. Trying again...")
                            self?.fetchCatImage() // Retry fetching if no breed info
                        }

                    } catch {
                        print("Failed to decode JSON: \(error)")
                    }
                }.resume()
            }
        }

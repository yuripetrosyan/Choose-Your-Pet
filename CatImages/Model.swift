//
//  Model.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/5/24.
//

import Foundation


struct CatImage: Codable {
    let url: String
    let breeds: [Breed]

}

struct DogImage: Codable {
    let url: String
    let breeds: [DogBreed]
}

struct DogBreed: Codable {
    let name: String
    let origin: String
    let temperament: String
    let life_span: String
}


struct Breed: Codable {
    let name: String
    let origin: String
    let description: String
    let temperament: String
    let life_span: String
    let dog_friendly: Int
}

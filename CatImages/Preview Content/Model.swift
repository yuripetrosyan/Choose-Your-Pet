//
//  Model.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/5/24.
//

import Foundation


struct CatImage: Codable {
    let url: String
    let breeds: [Breed] // Array because there can be multiple breeds

}


struct Breed: Codable {
    let name: String
    let origin: String
}

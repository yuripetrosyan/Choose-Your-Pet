//
//  PetAPI.swift
//  CatImages
//
//  Created by Yuri Petrosyan on 9/26/24.
//

import Foundation


protocol PetAPI {
    func fetchImage(completion: @escaping (String?) -> Void)
}

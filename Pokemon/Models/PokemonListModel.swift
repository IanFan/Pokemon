//
//  PokemonModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

struct PokemonListResponseModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListModel]?
}

struct PokemonListModel: Codable {
    let name: String
    let url: String
    
    var id: Int {
        guard let lastPathComponent = url.split(separator: "/").last else {
            return 0
        }
        let cleanedString = lastPathComponent.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return Int(cleanedString) ?? 0
    }
}

//
//  pokemonModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

struct PokemonResponseModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonModel]?
}

struct PokemonModel: Codable {
    let name: String
    let url: String
    
    var id: Int? {
        // Extract the ID from the URL
        guard let idString = url.split(separator: "/").last else {
            return nil
        }
        return Int(idString)
    }
}

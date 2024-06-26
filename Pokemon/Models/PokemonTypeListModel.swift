//
//  TypeListModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation

struct PokemonTypeListResponseModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonTypeListModel]?
}

struct PokemonTypeListModel: Codable {
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

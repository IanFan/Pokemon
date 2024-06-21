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
}

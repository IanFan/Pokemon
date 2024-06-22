//
//  HomePokemonListModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation

struct HomePokemonListModel: Codable {
    let id: Int
    let name: String
    let imageUrlStr: String
    let types: [String]
    let isFavorite: Bool
}

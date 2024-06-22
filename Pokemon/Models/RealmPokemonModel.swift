//
//  RealmPokemon.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/22.
//

import Foundation
import RealmSwift

class RealmPokemonModel: Object {
    @objc dynamic var pokemonID: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var detailUrl: String = ""
    @objc dynamic var spriteFrontUrl: String = ""
    @objc dynamic var isDetailDataFetched: Bool = false
    @objc dynamic var isFavorite: Bool = false
    var types = List<String>()
    
    override static func primaryKey() -> String? {
        return "pokemonID"
    }
}

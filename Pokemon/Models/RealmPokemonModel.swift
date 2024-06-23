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
    
    @objc dynamic var isDetailDataFetched: Bool = false
    @objc dynamic var spriteFrontUrl: String = ""
    var types = List<String>()
    
    @objc dynamic var isSpeciesDataFetched: Bool = false
    @objc dynamic var evolutionChainUrl: String = ""
    @objc dynamic var evolutionChainID: Int = 0
    
    @objc dynamic var isEvolutionDataFetched: Bool = false
    
    @objc dynamic var isFavorite: Bool = false
    
    override static func primaryKey() -> String? {
        return "pokemonID"
    }
}

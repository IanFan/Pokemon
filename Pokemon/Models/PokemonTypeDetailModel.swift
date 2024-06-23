//
//  PokemonTypeDetailModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation

struct PokemonTypeDetailModel: Codable {
    let damageRelations: DamageRelations?
    let gameIndices: [TypeGameIndex]?
    let generation: Generation?
    let id: Int
    let moveDamageClass: MoveDamageClass?
    let moves: [TypeMove]?
    let pastDamageRelations: [DamageRelations]?
    let pokemon: [PokemonSlot]?
    
    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
        case gameIndices = "game_indices"
        case generation
        case id
        case moveDamageClass = "move_damage_class"
        case moves
        case pastDamageRelations = "past_damage_relations"
        case pokemon
    }
}

struct DamageRelation: Codable {
    let name: String?
    let url: String?
}

struct DamageRelations: Codable {
    let doubleDamageFrom: [DamageRelation]?
    let doubleDamageTo: [DamageRelation]?
    let halfDamageFrom: [DamageRelation]?
    let halfDamageTo: [DamageRelation]?
    let noDamageFrom: [DamageRelation]?
    let noDamageTo: [DamageRelation]?
    
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
    }
}

struct TypeGameIndex: Codable {
    let gameIndex: Int?
    let generation: Generation?
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case generation
    }
}

struct MoveDamageClass: Codable {
    let name: String?
    let url: String?
}

struct TypeMove: Codable {
    let name: String?
    let url: String?
}

struct Pokemon: Codable {
    let name: String?
    let url: String?
}

struct PokemonSlot: Codable {
    let pokemon: Pokemon?
    let slot: Int?
}


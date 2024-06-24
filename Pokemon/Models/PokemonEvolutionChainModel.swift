//
//  PokemonEvolutionModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation

struct PokemonEvolutionChainModel: Codable {
    let id: Int
    let baby_trigger_item: PokemonItem?
    let chain: PokemonChainLink?
}

struct PokemonChainLink: Codable {
    let evolution_details: [EvolutionDetail]?
    let evolves_to: [PokemonChainLink]?
    let is_baby: Bool?
    let species: PokemonSpecies?
}

struct EvolutionDetail: Codable {
    let gender: Int?
    let held_item: PokemonItem?
    let item: PokemonItem?
    let known_move: PokemonItem?
    let known_move_type: PokemonItem?
    let location: PokemonItem?
    let min_affection: Int?
    let min_beauty: Int?
    let min_happiness: Int?
    let min_level: Int?
    let needs_overworld_rain: Bool?
    let party_species: PokemonItem?
    let party_type: PokemonItem?
    let relative_physical_stats: Int?
    let time_of_day: String?
    let trade_species: PokemonItem?
    let trigger: PokemonItem?
    let turn_upside_down: Bool?
}

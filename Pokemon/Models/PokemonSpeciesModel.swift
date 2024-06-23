//
//  PokemonSpeciesModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation

import Foundation

struct PokemonSpeciesModel: Codable {
    let id: Int
    let base_happiness: Int?
    let capture_rate: Int?
    let color: Color?
    let egg_groups: [EggGroup]?
    let evolution_chain: EvolutionChain?
    let evolves_from_species: EvolvesFromSpecies?
    let flavor_text_entries: [FlavorTextEntry]?
    let form_descriptions: [FormDescription]?
    let forms_switchable: Bool?
    let gender_rate: Int?
    let genera: [Genus]?
    let generation: Generation?
    let growth_rate: GrowthRate?
    let habitat: Habitat?
    let has_gender_differences: Bool?
    let hatch_counter: Int?
    let is_baby: Bool?
    let is_legendary: Bool?
    let is_mythical: Bool?
    let name: String?
    let names: [Name]?
    let order: Int?
    let pal_park_encounters: [PalParkEncounter]?
    let pokedex_numbers: [PokedexNumber]?
    let shape: Shape?
    let varieties: [Variety]?
}

struct Color: Codable {
    let name: String?
    let url: String?
}

struct EggGroup: Codable {
    let name: String?
    let url: String?
}

struct EvolutionChain: Codable {
    let url: String?
    
    var id: Int? {
        guard let lastPathComponent = url?.split(separator: "/").last else {
            return nil
        }
        let cleanedString = lastPathComponent.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return Int(cleanedString) ?? nil
    }
}

struct EvolvesFromSpecies: Codable {
    let name: String?
    let url: String?
}

struct FlavorTextEntry: Codable {
    let flavor_text: String?
    let language: Language?
    let version: Version?
}

struct FormDescription: Codable {}

struct Language: Codable {
    let name: String?
    let url: String?
}

struct Genus: Codable {
    let genus: String?
    let language: Language?
}

struct Generation: Codable {
    let name: String?
    let url: String?
}

struct GrowthRate: Codable {
    let name: String?
    let url: String?
}

struct Habitat: Codable {
    let name: String?
    let url: String?
}

struct Name: Codable {
    let language: Language?
    let name: String?
}

struct PalParkEncounter: Codable {
    let area: Area?
    let base_score: Int?
    let rate: Int?
}

struct Area: Codable {
    let name: String?
    let url: String?
}

struct PokedexNumber: Codable {
    let entry_number: Int?
    let pokedex: Pokedex?
}

struct Pokedex: Codable {
    let name: String?
    let url: String?
}

struct Shape: Codable {
    let name: String?
    let url: String?
}

struct Variety: Codable {
    let is_default: Bool?
    let pokemon: PokemonInfo?
}

struct PokemonInfo: Codable {
    let name: String?
    let url: String?
}



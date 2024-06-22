//
//  RealmManager.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/22.
//

import Foundation
import UIKit
import RealmSwift

class RealmManager {
    static func createPokemon(pokemonID: Int, name: String, detailUrl: String) {
        let realm = try! Realm()
                
        if let existingPokemon = getPokemon(byID: pokemonID) {
            try! realm.write {
                existingPokemon.name = name
                existingPokemon.detailUrl = detailUrl
            }
        } else {
            let newPokemon = RealmPokemonModel()
            newPokemon.pokemonID = pokemonID
            newPokemon.name = name
            newPokemon.detailUrl = detailUrl
            newPokemon.isDetailDataFetched = false
            
            try! realm.write {
                realm.add(newPokemon)
            }
        }
    }
    
    static func createOrUpdatePokemon(pokemon: RealmPokemonModel) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.create(RealmPokemonModel.self, value: pokemon, update: .modified)
        }
    }
    
    static func deleteAllPokemon() {
        let realm = try! Realm()
        
        try! realm.write {
            let allObjects = realm.objects(RealmPokemonModel.self)
            realm.delete(allObjects)
        }
    }
    
    static func deletePokemon(byID pokemonID: Int) {
        let realm = try! Realm()
        if let pokemon = getPokemon(byID: pokemonID) {
            try! realm.write {
                realm.delete(pokemon)
            }
        } else {
            print("Pokemon with ID \(pokemonID) not found.")
        }
    }
    
    static func deletePokemon(pokemon: RealmPokemonModel) {
        deletePokemon(byID: pokemon.pokemonID)
    }
    
    static func getPokemon(byID pokemonID: Int) -> RealmPokemonModel? {
        let realm = try! Realm()
        return realm.object(ofType: RealmPokemonModel.self, forPrimaryKey: pokemonID)
    }
    
    static func getOrCreatePokemon(byID pokemonID: Int) -> RealmPokemonModel {
        let realm = try! Realm()
        if let model = getPokemon(byID: pokemonID) {
            return model
        } else {
            let model = RealmPokemonModel()
            model.pokemonID = pokemonID
            return model
        }
    }
    
    static func isPokemonExist(byID pokemonID: Int) -> Bool {
        let realm = try! Realm()
        return getPokemon(byID: pokemonID) != nil
    }
    
    static func updatePokemonDetailFetched(pokemonID: Int, isDetailDataFetched: Bool) {
        let realm = try! Realm()

        if let pokemon = realm.object(ofType: RealmPokemonModel.self, forPrimaryKey: pokemonID) {
            try! realm.write {
                pokemon.isDetailDataFetched = isDetailDataFetched
            }
        }
    }
    
    static func updatePokemonFavorite(pokemonID: Int, isFavorite: Bool) {
        let realm = try! Realm()

        if let pokemon = realm.object(ofType: RealmPokemonModel.self, forPrimaryKey: pokemonID) {
            try! realm.write {
                pokemon.isFavorite = isFavorite
            }
        }
    }
}

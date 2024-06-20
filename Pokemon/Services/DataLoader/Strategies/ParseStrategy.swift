//
//  ParseStrategy.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

protocol DataParseParams {
    var data: Data { get }
}

protocol ParseStrategy {
    associatedtype ResultType
    associatedtype DataParseParams
    func parseParams(params: DataParseParams) -> ResultType?
}

// MARK: - PARSER Pokemon
struct DataParseParams_pokemon: DataParseParams {
    var data: Data
}

class ParseStrategy_pokemon: ParseStrategy {
    typealias DataParseParams = DataParseParams_pokemon
    typealias ResultType = PokemonResponseModel
    
    func parseParams(params: DataParseParams_pokemon) -> PokemonResponseModel? {
        let data = params.data
        
        let parser = PokemonParser()
        let result = parser.parse(data: data)
        
        switch result {
        case .success(let response):
            return response
        case .failure(let failure):
            return nil
        }
    }
}

// MARK: - PARSER PokemonDetail
struct DataParseParams_pokemonDetail: DataParseParams {
    var data: Data
}

class ParseStrategy_pokemonDetail: ParseStrategy {
    typealias DataParseParams = DataParseParams_pokemonDetail
    typealias ResultType = PokemonDetailModel
    
    func parseParams(params: DataParseParams_pokemonDetail) -> PokemonDetailModel? {
        let data = params.data
        
        let parser = PokemonDetailParser()
        let result = parser.parse(data: data)
        
        switch result {
        case .success(let response):
            return response
        case .failure(let failure):
            return nil
        }
    }
}



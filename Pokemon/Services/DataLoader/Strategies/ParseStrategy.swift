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

// MARK: - PARSER PokemonList
struct DataParseParams_pokemonList: DataParseParams {
    var data: Data
}

class ParseStrategy_pokemonList: ParseStrategy {
    typealias DataParseParams = DataParseParams_pokemonList
    typealias ResultType = PokemonListResponseModel
    
    func parseParams(params: DataParseParams_pokemonList) -> PokemonListResponseModel? {
        let data = params.data
        
        let parser = PokemonListParser()
        let result = parser.parse(data: data)
        
        switch result {
        case .success(let response):
            return response
        case .failure(_):
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
        case .failure(_):
            return nil
        }
    }
}

// MARK: - PARSER PokemonSpecies
struct DataParseParams_pokemonSpecies: DataParseParams {
    var data: Data
}

class ParseStrategy_pokemonSpecies: ParseStrategy {
    typealias DataParseParams = DataParseParams_pokemonSpecies
    typealias ResultType = PokemonSpeciesModel
    
    func parseParams(params: DataParseParams_pokemonSpecies) -> PokemonSpeciesModel? {
        let data = params.data
        
        let parser = PokemonSpeciesParser()
        let result = parser.parse(data: data)
        
        switch result {
        case .success(let response):
            return response
        case .failure(_):
            return nil
        }
    }
}

// MARK: - PARSER PokemonEvolutionChain
struct DataParseParams_pokemonEvolutionChain: DataParseParams {
    var data: Data
}

class ParseStrategy_pokemonEvolutionChain: ParseStrategy {
    typealias DataParseParams = DataParseParams_pokemonEvolutionChain
    typealias ResultType = PokemonEvolutionChainModel
    
    func parseParams(params: DataParseParams_pokemonEvolutionChain) -> PokemonEvolutionChainModel? {
        let data = params.data
        
        let parser = PokemonEvolutionChainParser()
        let result = parser.parse(data: data)
        
        switch result {
        case .success(let response):
            return response
        case .failure(_):
            return nil
        }
    }
}

// MARK: - PARSER PokemonTypeList
struct DataParseParams_pokemonTypeList: DataParseParams {
    var data: Data
}

class ParseStrategy_pokemonTypeList: ParseStrategy {
    typealias DataParseParams = DataParseParams_pokemonTypeList
    typealias ResultType = PokemonTypeListResponseModel
    
    func parseParams(params: DataParseParams_pokemonTypeList) -> PokemonTypeListResponseModel? {
        let data = params.data
        
        let parser = PokemonTypeListParser()
        let result = parser.parse(data: data)
        
        switch result {
        case .success(let response):
            return response
        case .failure(_):
            return nil
        }
    }
}

// MARK: - PARSER PokemonDetail
struct DataParseParams_pokemonTypeDetail: DataParseParams {
    var data: Data
}

class ParseStrategy_pokemonTypeDetail: ParseStrategy {
    typealias DataParseParams = DataParseParams_pokemonTypeDetail
    typealias ResultType = PokemonTypeDetailModel
    
    func parseParams(params: DataParseParams_pokemonTypeDetail) -> PokemonTypeDetailModel? {
        let data = params.data
        
        let parser = PokemonTypeDetailParser()
        let result = parser.parse(data: data)
        
        switch result {
        case .success(let response):
            return response
        case .failure(_):
            return nil
        }
    }
}


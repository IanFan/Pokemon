//
//  PokemonEvolutionChainParser.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation

class PokemonEvolutionChainParser: JSONParserStrategy {
    typealias ParseResult = PokemonEvolutionChainModel
    
    func parse(data: Data) -> Result<ParseResult, Error> {
        do {
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(PokemonEvolutionChainModel.self, from: data)
            return .success(responseModel)
        } catch {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(json as Any)
            } catch {
                
            }
            print("Parser Failed to load data: \(error.localizedDescription)")
            return .failure(ParseError.parseError)
        }
    }
}


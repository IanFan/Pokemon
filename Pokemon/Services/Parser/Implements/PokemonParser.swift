//
//  PokemonParser.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

class PokemonParser: JSONParserStrategy {
    typealias ParseResult = PokemonResponseModel
    
    func parse(data: Data) -> Result<ParseResult, Error> {
        do {
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(PokemonResponseModel.self, from: data)
            return .success(responseModel)
        } catch {
            print("Parser Failed to load data: \(error.localizedDescription)")
            return .failure(ParseError.parseError)
        }
    }
}

//
//  PokemonTypeListParser.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation

class PokemonTypeListParser: JSONParserStrategy {
    typealias ParseResult = PokemonTypeListResponseModel
    
    func parse(data: Data) -> Result<ParseResult, Error> {
        do {
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(PokemonTypeListResponseModel.self, from: data)
            return .success(responseModel)
        } catch {
            print("Parser Failed to load data: \(error.localizedDescription)")
            return .failure(ParseError.parseError)
        }
    }
}

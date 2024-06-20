//
//  PokemonDetailParser.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

class PokemonDetailParser: JSONParserStrategy {
    typealias ParseResult = PokemonDetailModel
    
    func parse(data: Data) -> Result<ParseResult, Error> {
        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            print(json)
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(PokemonDetailModel.self, from: data)
            return .success(responseModel)
        } catch {
            print("Parser Failed to load data: \(error.localizedDescription)")
            return .failure(ParseError.parseError)
        }
    }
}

//
//  JsonParserStrategy.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

protocol JSONParserStrategy {
    associatedtype ParseResult
    
    func parse(data: Data) -> Result<ParseResult, Error>
}

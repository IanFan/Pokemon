//
//  PokemonSpeciesLoaderTests.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/23.
//

import XCTest
@testable import Pokemon

final class PokemonSpeciesParserTests: XCTestCase {
    var loader: PokemonSpeciesLoader!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let params = FileParams_pokemonSpecies(name: "bulbasaur", id: 1)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
        
        loader = PokemonSpeciesLoader()
    }

    override func tearDownWithError() throws {
        loader = nil
        super.tearDown()
    }
    
    func testLoadDataFromCache() async throws {
        let params = FileParams_pokemonSpecies(name: "bulbasaur", id: 1)
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(_):
            switch try loader.loadDataFromCache(params: params) {
            case .success(let responseModel):
                XCTAssertNotNil(responseModel)
                XCTAssertTrue(responseModel.name?.count ?? 0 > 0)
            case .failure(let error):
                XCTFail("\(#function) error \(error)")
            }
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
    
    func testLoadDataOnline() async throws {
        let params = FileParams_pokemonSpecies(name: "bulbasaur", id: 1)
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(let responseModel):
            XCTAssertNotNil(responseModel)
            XCTAssertTrue(responseModel.name?.count ?? 0 > 0)
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
}

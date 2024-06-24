//
//  PokemonEvolutionChainParserTests.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/23.
//

import XCTest
@testable import Pokemon

final class PokemonEvolutionChainLoaderTests: XCTestCase {
    var loader: PokemonEvolutionChainLoader!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let params = FileParams_pokemonEvolutionChain(id: 1)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
        
        loader = PokemonEvolutionChainLoader()
    }

    override func tearDownWithError() throws {
        loader = nil
        super.tearDown()
    }
    
    func testLoadDataFromCache() async throws {
        let params = FileParams_pokemonEvolutionChain(id: 1)
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(_):
            switch try loader.loadDataFromCache(params: params) {
            case .success(let responseModel):
                XCTAssertNotNil(responseModel)
                XCTAssertNotNil(responseModel.chain)
            case .failure(let error):
                XCTFail("\(#function) error \(error)")
            }
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
    
    func testLoadDataOnline() async throws {
        let params = FileParams_pokemonEvolutionChain(id: 1)
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(let responseModel):
            XCTAssertNotNil(responseModel)
            XCTAssertNotNil(responseModel.chain)
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
}

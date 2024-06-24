//
//  PokemonDetailLoader.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/21.
//

import XCTest
@testable import Pokemon

final class PokemonDetailLoaderTests: XCTestCase {
    var loader: PokemonDetailLoader!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let params = FileParams_pokemonDetail(name: "bulbasaur", id: 1)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
        
        loader = PokemonDetailLoader()
    }

    override func tearDownWithError() throws {
        loader = nil
        super.tearDown()
    }
    
    func testLoadDataFromCache() async throws {
        let params = FileParams_pokemonDetail(name: "bulbasaur", id: 1)
        
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
        let params = FileParams_pokemonDetail(name: "bulbasaur", id: 1)
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(let responseModel):
            XCTAssertNotNil(responseModel)
            XCTAssertTrue(responseModel.name?.count ?? 0 > 0)
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
}

//
//  PokemonTypeDetailLoaderTests.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/21.
//

import XCTest
@testable import Pokemon

final class PokemonTypeDetailLoaderTestsTests: XCTestCase {
    var loader: PokemonTypeDetailLoader!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let params = FileParams_pokemonTypeDetail(name: "flying", id: 3)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
        
        loader = PokemonTypeDetailLoader()
    }

    override func tearDownWithError() throws {
        loader = nil
        super.tearDown()
    }
    
    // to do
    func testLoadDataFromCache() async throws {
        let params = FileParams_pokemonTypeDetail(name: "flying", id: 3)
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(_):
            switch try loader.loadDataFromCache(params: params) {
            case .success(let responseModel):
                XCTAssertNotNil(responseModel)
                XCTAssertTrue(responseModel.pokemon?.count ?? 0 > 0)
            case .failure(let error):
                XCTFail("\(#function) error \(error)")
            }
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
    
    func testLoadDataOnline() async throws {
        let params = FileParams_pokemonTypeDetail(name: "flying", id: 3)
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(let responseModel):
            XCTAssertNotNil(responseModel)
            XCTAssertTrue(responseModel.pokemon?.count ?? 0 > 0)
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
}

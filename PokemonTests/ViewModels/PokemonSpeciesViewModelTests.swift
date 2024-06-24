//
//  PokemonSpeciesViewModel.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/24.
//

import XCTest
@testable import Pokemon

final class PokemonSpeciesViewModelTests: XCTestCase {
    var viewModel: PokemonSpeciesViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let params = FileParams_pokemonSpecies(name: "bulbasaur", id: 1)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
        
        viewModel = PokemonSpeciesViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadData() async throws {
        let expectation = self.expectation(description: "Async loadData")
        
        viewModel.loadData(id: 1, name: "bulbasaur")
        
        viewModel.successAction = {
            guard let viewModel = self.viewModel else {
                XCTFail("\(#function) error")
                expectation.fulfill()
                return
            }
            XCTAssertNotNil(viewModel.pokemonSpeciesModel)
            expectation.fulfill()
        }
        
        viewModel.failAction = {
            XCTFail("\(#function) error")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 30.0)
    }
    
    func testPerformanceExample1() throws {
        let expectation = self.expectation(description: "Async loadData")
        var startTime: TimeInterval = 0
        var endTime: TimeInterval = 0
        
        startTime = Date().timeIntervalSince1970
        
        viewModel.loadData(id: 1, name: "bulbasaur")
        
        viewModel.successAction = {
            endTime = Date().timeIntervalSince1970
            expectation.fulfill()
        }
        
        viewModel.failAction = {
            XCTFail("testPerformanceExample1 error")
            endTime = Date().timeIntervalSince1970
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 30.0)
        
        measure {
            let totalTime = endTime - startTime
            print("PokemonSpeciesViewModelTests Total time: \(totalTime) seconds")
        }
    }
}

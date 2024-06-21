//
//  PokemonDetailViewModelTests.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/21.
//

import XCTest
@testable import Pokemon

final class PokemonDetailViewModelTests: XCTestCase {
    var viewModel: PokemonDetailViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let params = FileParams_pokemonDetail(name: "bulbasaur", id: 1)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
        
        viewModel = PokemonDetailViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadData() async throws {
        let expectation = self.expectation(description: "Async loadData")
        
        viewModel.loadData(isRefresh: false, name: "bulbasaur", id: 1)
        
        viewModel.successAction = {
            guard let viewModel = self.viewModel else {
                XCTFail("\(#function) error")
                expectation.fulfill()
                return
            }
            XCTAssertNotNil(viewModel.pokemonDetailModel)
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
        
        viewModel.loadData(isRefresh: false, name: "bulbasaur", id: 1)
        
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
            print("PokemonDetailViewModelTests Total time: \(totalTime) seconds")
        }
    }
}


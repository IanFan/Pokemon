//
//  PokemonListViewModelTests.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/21.
//

import XCTest
@testable import Pokemon

final class PokemonListViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        cleanJson(page: 0)
        cleanJson(page: 1)
        
        viewModel = PokemonListViewModel()
    }
    
    private func cleanJson(page: Int) {
        let params = FileParams_pokemonList(page: page)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadData() async throws {
        let expectation1 = self.expectation(description: "First loadData")
        let expectation2 = self.expectation(description: "Second loadData")
        let params = FileParams_pokemonList(page: 0)
        viewModel.loadData(isRefresh: false)
        
        viewModel.successAction = {
            guard let viewModel = self.viewModel else {
                XCTFail("\(#function) error")
                expectation1.fulfill()
                return
            }
            XCTAssertTrue(viewModel.pokemons.count == params.limit*viewModel.page)
            
            viewModel.loadData(isRefresh: false)
            viewModel.successAction = {
                guard let viewModel = self.viewModel else {
                    XCTFail("\(#function) error")
                    expectation2.fulfill()
                    return
                }
                XCTAssertTrue(viewModel.pokemons.count ==  params.limit*viewModel.page)
                expectation2.fulfill()
            }
            viewModel.failAction = {
                XCTFail("\(#function) error")
                expectation2.fulfill()
            }
            expectation1.fulfill()
        }
        
        viewModel.failAction = {
            XCTFail("\(#function) error")
            expectation1.fulfill()
        }
        
        await fulfillment(of: [expectation1, expectation2], timeout: 30.0)
    }
    
    func testPerformanceExample1() throws {
        let expectation = self.expectation(description: "Async loadData")
        var startTime: TimeInterval = 0
        var endTime: TimeInterval = 0
        
        startTime = Date().timeIntervalSince1970
        
        viewModel.loadData(isRefresh: false)
        
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
            print("PokemonListViewModelTests Total time: \(totalTime) seconds")
        }
    }
}


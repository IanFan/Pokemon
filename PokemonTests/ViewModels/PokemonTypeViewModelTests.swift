//
//  PokemonTypeViewModelTests.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/21.
//

import XCTest
@testable import Pokemon

final class PokemonTypeViewModelTests: XCTestCase {
    var viewModel: PokemonTypeViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        cleanTypeListJson(page: 0)
        for i in 0..<30 {
            cleanTypeDetailJson(id: i)
        }
        
        viewModel = PokemonTypeViewModel()
    }
    
    private func cleanTypeListJson(page: Int) {
        let params = FileParams_pokemonTypeList(page: page)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
    }
    
    private func cleanTypeDetailJson(id: Int) {
        let params = FileParams_pokemonDetail(name: "", id: id)
        let key = params.cacheKey
        JsonHelper().clearJson(forKey: key)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadData() async throws {
        let expectation = self.expectation(description: "Async loadData")
        
        viewModel.loadData(isRefresh: false)
        
        viewModel.successAction = {
            guard let viewModel = self.viewModel else {
                XCTFail("\(#function) error")
                expectation.fulfill()
                return
            }
            XCTAssertTrue(viewModel.pokemonTypeList.count > 0)
            XCTAssertTrue(viewModel.pokemonTypeDetailDic.count > 0)
            XCTAssertTrue(viewModel.pokemonNameTypeDic.count > 0)
            XCTAssertTrue(viewModel.pokemonIdTypeDic.count > 0)
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
        
        wait(for: [expectation], timeout: 15.0)
        
        measure {
            let totalTime = endTime - startTime
            print("PokemonTypeViewModelTests Total time: \(totalTime) seconds")
        }
    }
}


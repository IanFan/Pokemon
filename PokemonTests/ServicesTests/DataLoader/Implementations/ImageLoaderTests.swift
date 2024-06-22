//
//  ImageLoaderTests.swift
//  PokemonTests
//
//  Created by Ian Fan on 2024/6/21.
//

import XCTest
@testable import Pokemon

final class ImageLoaderTests: XCTestCase {
    var loader: ImageLoader!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let params = FileParams_file(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png")
        let key = params.cacheKey
        FileHelper.deleteDataFromDisk(forKey: key)
        
        loader = ImageLoader()
    }

    override func tearDownWithError() throws {
        loader = nil
        super.tearDown()
    }
    
    func testLoadDataFromCache() async throws {
        let params = FileParams_file(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png")
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(_):
            switch try loader.loadDataFromCache(params: params) {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure(let error):
                XCTFail("\(#function) error \(error)")
            }
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }
    
    func testLoadDataOnline() async throws {
        let params = FileParams_file(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png")
        
        switch try await loader.loadDataOnline(params: params) {
        case .success(let image):
            XCTAssertNotNil(image)
        case .failure(let error):
            XCTFail("\(#function) error \(error)")
        }
    }

    func testPerformanceExample1() throws {
        let params = FileParams_file(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png")
        
        self.measure {
            do {
                let _ = try loader.loadDataFromCache(params: params)
            } catch {
            }
        }
    }
    
    func testPerformanceExample2() throws {
        let params = FileParams_file(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png")
        
        self.measure {
            do {
                let _ = try loader.loadDataLocal(params: params)
            } catch {
            }
        }
    }
}

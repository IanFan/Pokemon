//
//  PokemonUITests.swift
//  PokemonUITests
//
//  Created by Ian Fan on 2024/6/20.
//

import XCTest

final class PokemonUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testHomeViewAndDetailView() throws {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        let homeView = app.otherElements["HomeView"]
        expectation(for: existsPredicate, evaluatedWith: homeView, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(homeView.exists, "HomeView should exist")
        
        let collectionView = app.collectionViews.firstMatch
        expectation(for: existsPredicate, evaluatedWith: collectionView, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(collectionView.exists, "CollectionView should exist")
        
        let cell = collectionView.cells.element(boundBy: 0)
        expectation(for: existsPredicate, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(cell.exists, "At least one cell should be loaded")
        
        cell.tap()
        
        let detailView = app.otherElements["DetailView"]
        expectation(for: existsPredicate, evaluatedWith: detailView, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(detailView.exists, "DetailView should be present after tapping cell")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

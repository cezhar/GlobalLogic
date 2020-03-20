//
//  TestUITests.swift
//  TestUITests
//
//  Created by Cezhar Arévalo on 20-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import XCTest
@testable import Test

class TestUITests: XCTestCase {

    let song = "Overture 1928"
    let badSong = "dkjahgsdfkjasfnawe"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func testLoadMusic(){
        let app = XCUIApplication()
        app.launch()
        let searchField = app.textFields["Search a song here..."]
        XCTAssert(searchField.exists)
        searchField.tap()
        searchField.typeText(song)
        app.keyboards.buttons["intro"].tap()
        let myTable = app.tables.matching(identifier: "table")
        XCTAssert(myTable.element.exists)
        let cell = myTable.cells.element(matching: .cell, identifier: "songCell_0")
        XCTAssert(cell.exists)
        cell.tap()
        let detailTable = app.tables.matching(identifier: "detailTable")
        XCTAssert(detailTable.element.exists)
        let detailCell = detailTable.cells.element(matching: .cell, identifier: "detailCell_1")
        XCTAssert(detailCell.exists)
        detailCell.tap()
        sleep(18)
        let close = app.buttons["Close"]
        XCTAssert(close.exists)
        close.tap()
    }
    
    func testBadMusic() {
        let app = XCUIApplication()
        app.launch()
        let searchField = app.textFields["Search a song here..."]
        XCTAssert(searchField.exists)
        searchField.tap()
        searchField.typeText(badSong)
        app.keyboards.buttons["intro"].tap()
        let error = app.staticTexts["Song not found..."]
        XCTAssert(error.exists)
    }
}

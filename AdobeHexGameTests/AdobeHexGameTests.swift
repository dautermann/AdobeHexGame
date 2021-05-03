//
//  AdobeHexGameTests.swift
//  AdobeHexGameTests
//
//  Created by Michael Dautermann on 4/27/21.
//

import XCTest
@testable import AdobeHexGame

class AdobeHexGameTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCountOfCells() throws {
        let hexGrid = HexGrid(gridDisplayView: nil)

        XCTAssert(hexGrid.flattenedGrid.count == 19, "should be 19 cells in the hex grid")
    }

    func testTopLeftAdjacentCells() throws {
        let hexGrid = HexGrid(gridDisplayView: nil)

        if let firstCell = hexGrid.getCellWithCoordinate(col: 1, row: 0) {
            XCTAssert(firstCell.adjacentCells?.count == 3, "C 1 R 0 should have three adjacent cells")
        } else {
            XCTFail("no cell with C1 R0 found!")
        }
    }

    func testMiddleAdjacentCells() throws {
        let hexGrid = HexGrid(gridDisplayView: nil)

        if let middleCell = hexGrid.getCellWithCoordinate(col: 2, row: 3) {
            XCTAssert(middleCell.adjacentCells?.count == 6, "C2 R3 should be surrounded by 6 cells!")
        } else {
            XCTFail("no cell with C2 R3 found!")
        }
    }

    func testGetNonExistentCell() throws {
        let hexGrid = HexGrid(gridDisplayView: nil)

        /// if I did a revision of the code where I set up the coordinate system via some other method,
        /// this test would be useful to make sure we maintain the odd-r symmetry
        if let _ = hexGrid.getCellWithCoordinate(col: 0, row: 0) {
            XCTFail("there should be no visible cell with coordinates C0 R0")
        }
    }

}

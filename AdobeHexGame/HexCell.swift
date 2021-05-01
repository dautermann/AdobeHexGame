//
//  HexCell.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import Foundation

struct Coordinate {
    let x: Int
    let y: Int
}

class HexCell: CustomStringConvertible {
    let x: Int
    let y: Int
    var value: Int = 0
    var adjacentCells: [HexCell]?
    var zPlaced: Bool = false
    var randomAdjacentCells: [HexCell]? {
        return adjacentCells?.shuffled()
    }

    var description: String {
        return "<\(type(of: self)): x = \(x) y = \(y)>"
    }

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

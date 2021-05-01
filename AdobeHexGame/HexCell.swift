//
//  HexCell.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import Foundation

class HexCell: CustomStringConvertible {
    let col: Int
    let row: Int
    var value: Int = 0
    var tripletIndex: Int = 0
    var adjacentCells: [HexCell]?
    var zPlaced: Bool = false
    var randomAdjacentCells: [HexCell]? {
        return adjacentCells?.shuffled()
    }

    var description: String {
        return "<\(type(of: self)): column = \(col) row = \(row)>"
    }

    init(col: Int, row: Int) {
        self.row = row
        self.col = col
    }
}

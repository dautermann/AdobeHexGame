//
//  HexCell.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import Foundation

struct ColRow {
    let col: Int
    let row: Int
}

class HexCell: CustomStringConvertible {
    let col: Int
    let row: Int
    var value: Int = 0
    /// there can be 6 possible triplet sets; 0 means unassigned
    var tileIndex: Int = 0
    var adjacentCells: [HexCell]?
    /// used to randomly inspect a neighbor for the triplet (three circle set) we are hoping to reserve
    var randomAdjacentCells: [HexCell]? {
        return adjacentCells?.shuffled()
    }

    /// this is why we need to be a CustomStringConvertible;
    /// having a "description" is super handy!
    var description: String {
        return "<\(type(of: self)): column = \(col) row = \(row)>"
    }

    init(col: Int, row: Int) {
        self.row = row
        self.col = col
    }
}

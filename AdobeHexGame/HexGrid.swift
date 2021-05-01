//
//  HexGrid.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import Foundation

enum Parity {
    case even, odd

    init<T>(_ integer: T) where T : BinaryInteger {
        self = integer.isMultiple(of: 2) ? .even : .odd
    }
}

extension BinaryInteger {
    var parity: Parity { Parity(self) }
}

struct ColRow {
    let col: Int
    let row: Int
}

class HexGrid {

    // brute force set up grid of 19 cells
    //
    // “odd-r” horizontal layout shoves odd rows right
    let grid: [[HexCell]] =
        [[HexCell(col: 1, row: 0), HexCell(col: 2, row: 0), HexCell(col: 3, row: 0)],
         [HexCell(col: 0, row: 1), HexCell(col: 1, row: 1), HexCell(col: 2, row: 1), HexCell(col: 3, row: 1)],
         [HexCell(col: 0, row: 2), HexCell(col: 1, row: 2), HexCell(col: 2, row: 2), HexCell(col: 3, row: 2), HexCell(col: 4, row: 2)],
         [HexCell(col: 0, row: 3), HexCell(col: 1, row: 3), HexCell(col: 2, row: 3), HexCell(col: 3, row: 3)],
         [HexCell(col: 1, row: 4), HexCell(col: 2, row: 4), HexCell(col: 3, row: 4)]]

    lazy var flattenedGrid: [HexCell] = {
        let flattenedGrid = Array(grid.joined())
        return flattenedGrid
    }()

    init() {
        setUpAdjacentCells()
    }

    func getCellWithCoordinate(col: Int, row: Int) -> HexCell? {
        return flattenedGrid.first(where: { $0.col == col && $0.row == row })
    }

    func setUpAdjacentCells() {
        let oddr_directions: [[ColRow]] = [[ColRow(col: 1, row: 0), ColRow( col: 0, row: -1), ColRow(col: -1, row: -1),
                                         ColRow(col: -1, row: 0), ColRow(col: -1, row: +1), ColRow(col: 0, row: 1)],
                                        [ColRow(col: 1, row: 0), ColRow( col: 1, row: -1), ColRow(col: 0, row: -1),
                                          ColRow(col: -1, row: 0), ColRow(col: 0, row: +1), ColRow(col: 1, row: 1)]]
        for cell in flattenedGrid {
            var adjacentCells = [HexCell]()
            if cell.col == 2 && cell.row == 4 {
                Swift.print("col 2 row 4")
            }
            for eachDirection in oddr_directions[cell.row.parity == .even ? 0 : 1] {
                let offsetCol = cell.col + eachDirection.col
                let offsetRow = cell.row + eachDirection.row
                if let neighborCell = getCellWithCoordinate(col: offsetCol, row: offsetRow) {
                    adjacentCells.append(neighborCell)
                }
            }
            cell.adjacentCells = adjacentCells
            Swift.print("cell column \(cell.col) & row \(cell.row) has \(adjacentCells.count) adjacentCells \(adjacentCells)")
        }
    }

    func printTripletIndexGrid() {
        for row in 0...4 {
            var lineToPrint: String = ""
            for column in 0...4 {
                if let cell = getCellWithCoordinate(col: column, row: row) {
                    lineToPrint.append("\(column) \(row) \(cell.tripletIndex) * ")
                } else {
                    lineToPrint.append("   * ")
                }
            }
            Swift.print("\(lineToPrint)")
        }
    }

    func printHexGrid() {
        for row in 0...4 {
            var lineToPrint: String = ""
            for column in 0...4 {
                if let cell = getCellWithCoordinate(col: column, row: row) {
                    lineToPrint.append("\(column) \(row) \(cell.value) * ")
                } else {
                    lineToPrint.append("     * ")
                }
            }
            Swift.print("\(lineToPrint)")
        }
    }

    func assignZs(triplets: [Triplet]) {

        for nthThree in 1...6 {
            var successfullyAssigned = false

            repeat {
                let randomPlacement = Int.random(in: 0...18)
                let primaryCell = flattenedGrid[randomPlacement]
                Swift.print("trying to place to C\(primaryCell.col) R\(primaryCell.row)")

                var secondCell: HexCell? = nil
                var thirdCell: HexCell? = nil
                if primaryCell.tripletIndex == 0, let pCellAdjacentCells = primaryCell.randomAdjacentCells {
                    for potentialCell in pCellAdjacentCells {
                        // Swift.print("checking col \(potentialCell.col) row \(potentialCell.row) has \(potentialCell.value) -- placedX \(placedX) placedY \(placedY)")
                        if potentialCell.tripletIndex == 0 {
                            if secondCell == nil {
                                potentialCell.tripletIndex = nthThree
                                secondCell = potentialCell
                            } else if thirdCell == nil {
                                potentialCell.tripletIndex = nthThree
                                thirdCell = potentialCell
                                successfullyAssigned = true
                                primaryCell.tripletIndex = nthThree
                                Swift.print("\(nthThree) assigned to C\(primaryCell.col) R\(primaryCell.row); C\(secondCell?.col ?? -1) R\(secondCell?.row ?? -1); C\(potentialCell.col) R\(potentialCell.row)")
                                printTripletIndexGrid()

                            } else {
                                // all neighbors assigned... we'll have to get another random placement to attempt a triplet
//                                Swift.print("all neighbors are assigned... get another random placement")
//                                Swift.print("NOPE")
//                                printTripletIndexGrid()
                            }
                        }
                    }
                    // all neighbors assigned... we'll have to get another random placement to attempt a triplet
                    if thirdCell == nil, let clearThisCell = secondCell {
                        clearThisCell.tripletIndex = 0
                    }
                }
            } while (successfullyAssigned == false)
        }
        Swift.print("WHOA GOT IT ALL")
        printTripletIndexGrid()

        return

        for eachTriplet in triplets {
            var successfullyPlaced = false

            repeat {
                var placedX = false
                var placedY = false
                let randomPlacement = Int.random(in: 0...18)
                // assign z first
                // then assign x & y to random adjacents
                let zCell = flattenedGrid[randomPlacement]
                if zCell.value == 0, let zCellAdjacentCells = zCell.randomAdjacentCells {
                    // and if we find openings for x, y & z together, THEN assign all three and move on
                    Swift.print("*** looking at col \(zCell.col) row \(zCell.row) to POTENTIALLY place \(eachTriplet.z)")
                    for potentialCell in zCellAdjacentCells {
                        // Swift.print("checking col \(potentialCell.col) row \(potentialCell.row) has \(potentialCell.value) -- placedX \(placedX) placedY \(placedY)")
                        if potentialCell.value == 0 {
                            if placedX == false {
                                potentialCell.value = eachTriplet.x
                                placedX = true
                                Swift.print("placed x \(eachTriplet.x) into col \(potentialCell.col) row \(potentialCell.row)")
                            } else if placedY == false {
                                potentialCell.value = eachTriplet.y
                                placedY = true
                                Swift.print("placed y \(eachTriplet.y) into col \(potentialCell.col) row \(potentialCell.row)")
                                break
                            }
                        }
                    }
                    if placedX == false && placedY == false {
                        Swift.print("NOPE")
                        printHexGrid()
                    }
                    
                    if placedX == true && placedY == true {
                        Swift.print("placed z \(eachTriplet.z) into col \(zCell.col) row \(zCell.row)")
                        successfullyPlaced = true
                        zCell.value = eachTriplet.z
                    }

                }
            } while (successfullyPlaced == false)

        }
        Swift.print("all done placing")
    }

}

struct Triplet {
    let x: Int
    let y: Int
    let z: Int
}

class CreateRandomTriplets {
    var bonus = Int.random(in: 1...999)
    var triplets = [Triplet]()
    init() {
        for _ in 0...5 {
            let x = Int.random(in: 1...50)
            let y = Int.random(in: 1...19)
            let z = x * y
            let newTriplet = Triplet(x: x, y: y, z: z)
            triplets.append(newTriplet)
            Swift.print("\(x) * \(y) = \(z)")
        }
        Swift.print("\(bonus)")
    }
}

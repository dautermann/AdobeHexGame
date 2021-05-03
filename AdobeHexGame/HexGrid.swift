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

struct Triplet {
    let first: HexCell
    let second: HexCell
    let third: HexCell
}

class HexGrid {
    weak var gridDisplayView: GridDisplayView?
    
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

    init(gridDisplayView: GridDisplayView) {
        setUpAdjacentCells()
        self.gridDisplayView = gridDisplayView
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
    
    /// divide the 19 circles into triples (and of course one is left over)
    func reserveTriplets() -> [Triplet] {
        var tripletArray = [Triplet]()
        var successfullyPlacedEverything = false
        repeat {
            /// triplet index is 1 through 6; 0 means unassigned
            for nthThree in 1...6 {
                var finishedWithNth = false
                var tryingToPlace: Int = 0

                repeat {
                    let randomPlacement = Int.random(in: 0...18)
                    let primaryCell = flattenedGrid[randomPlacement]
                    Swift.print("trying to place \(nthThree) to C\(primaryCell.col) R\(primaryCell.row)")
                    
                    /// This is brute force and if I had another day to think about how to do this properly, I bet I could come up
                    /// with an algorithmic solution.  Anyways, what's happening here is that we've gone too long without
                    /// finding a place to place a cell with two empty adjacents, so we'll burn this grid down and start over
                    tryingToPlace += 1
                    if (tryingToPlace >= 50) {
                        Swift.print("hey!")
                        if nthThree == 5 {
                            Swift.print("WHY")
                        }
                        for eachCell in flattenedGrid {
                            eachCell.tripletIndex = 0
                        }
                        tripletArray.removeAll()
                        finishedWithNth = true
                    } else {
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
                                        finishedWithNth = true
                                        primaryCell.tripletIndex = nthThree
                                        Swift.print("\(nthThree) assigned to C\(primaryCell.col) R\(primaryCell.row); C\(secondCell?.col ?? -1) R\(secondCell?.row ?? -1); C\(potentialCell.col) R\(potentialCell.row)")
                                        printTripletIndexGrid()
                                        if let actualSecondCell = secondCell {
                                            let newTriplet = Triplet(first: primaryCell, second: actualSecondCell, third: potentialCell)
                                            tripletArray.append(newTriplet)
                                        }
                                        if nthThree == 6 {
                                            successfullyPlacedEverything = true
                                        }
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
                    }
                } while (finishedWithNth == false)
            }
        } while (successfullyPlacedEverything == false)
        return tripletArray
    }
      
    /// now that we have assigned three circles to tripletIndexes
    /// distribute the actual triplet values
    func allocateXYZ(xyzArray: [XYZ], into tripletArray: [Triplet]) {
        for (index,eachTriplet) in tripletArray.enumerated() {
            let xyzToAssign = xyzArray[index]
            eachTriplet.first.value = xyzToAssign.x
            eachTriplet.second.value = xyzToAssign.y
            eachTriplet.third.value = xyzToAssign.z
        }
        if let gridDisplay = gridDisplayView {
            gridDisplay.updateGridDisplay(from: flattenedGrid)
        }
    }
}

struct XYZ {
    let x: Int
    let y: Int
    let z: Int
}

class CreateRandomXYZ {
    var bonus = Int.random(in: 1...999)
    var xyzs = [XYZ]()
    init() {
        for _ in 0...5 {
            let x = Int.random(in: 1...50)
            let y = Int.random(in: 1...19)
            let z = x * y
            let newXYZ = XYZ(x: x, y: y, z: z)
            xyzs.append(newXYZ)
            Swift.print("\(x) * \(y) = \(z)")
        }
        Swift.print("\(bonus)")
    }
}

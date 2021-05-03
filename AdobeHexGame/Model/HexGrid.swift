//
//  HexGrid.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import Foundation

struct Tile {
    let first: HexCell
    let second: HexCell
    let third: HexCell
}

class HexGrid {
    weak var gridDisplayView: GridDisplayView?
    
    /// brute force set up grid of 19 cells
    ///
    /// “odd-r” horizontal layout shoves odd rows right
    let grid: [[HexCell]] =
        [[HexCell(col: 1, row: 0), HexCell(col: 2, row: 0), HexCell(col: 3, row: 0)],
         [HexCell(col: 0, row: 1), HexCell(col: 1, row: 1), HexCell(col: 2, row: 1), HexCell(col: 3, row: 1)],
         [HexCell(col: 0, row: 2), HexCell(col: 1, row: 2), HexCell(col: 2, row: 2), HexCell(col: 3, row: 2), HexCell(col: 4, row: 2)],
         [HexCell(col: 0, row: 3), HexCell(col: 1, row: 3), HexCell(col: 2, row: 3), HexCell(col: 3, row: 3)],
         [HexCell(col: 1, row: 4), HexCell(col: 2, row: 4), HexCell(col: 3, row: 4)]]

    /// flatten out the grid for easy reference when needed
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

    /// leaving these functions around because they were so helpful with debugging
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

    /// leaving these functions around because they were so helpful with debugging
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
    func reserveTiles() -> [Tile] {
        var tileArray = [Tile]()
        var successfullyPlacedEverything = false
        repeat {
            /// tile index is 1 through 6; 0 means unassigned
            for nthThree in 1...6 {
                var finishedWithNth = false
                var tryingToPlace: Int = 0

                repeat {
                    let randomPlacement = Int.random(in: 0...18)
                    let primaryCell = flattenedGrid[randomPlacement]
                    Swift.print("trying to place \(nthThree) to C\(primaryCell.col) R\(primaryCell.row)")
                    
                    /// I wish I knew the correct set of keywords to use to GoOgLe up  a beautiful algorithmic solution.
                    /// So this is brute force and if I had another day to think about how to do this properly, I bet I could come up
                    /// with a sexier approach. Anyways, what's happening here is that we've gone too long without
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
                        tileArray.removeAll()
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
                                            let newTriplet = Tile(first: primaryCell, second: actualSecondCell, third: potentialCell)
                                            tileArray.append(newTriplet)
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
                            // all neighbors assigned... we'll have to get another random placement to attempt a tile
                            if thirdCell == nil, let clearThisCell = secondCell {
                                clearThisCell.tripletIndex = 0
                            }
                        }
                    }
                } while (finishedWithNth == false)
            }
        } while (successfullyPlacedEverything == false)
        return tileArray
    }
      
    /// now that we have assigned three circles to tripletIndexes
    /// distribute the actual X Y Z values to the tiles
    func allocateRandoms(with randoms: CreateRandomXYZ , into tileArray: [Tile]) {
        for (index,eachTile) in tileArray.enumerated() {
            let xyzToAssign = randoms.xyzs[index]
            eachTile.first.value = xyzToAssign.x
            eachTile.second.value = xyzToAssign.y
            eachTile.third.value = xyzToAssign.z
        }
        if let unallocatedCell = flattenedGrid.first(where: { $0.tripletIndex == 0 }) {
            unallocatedCell.value = randoms.bonus
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

/// class that creates random things used in the hexagonal grid
class CreateRandomXYZ {
    var bonus = Int.random(in: 1...950)
    var xyzs = [XYZ]()
    init() {
        for _ in 0...5 {
            let x = Int.random(in: 1...50)
            let y = Int.random(in: 1...19)
            let z = x * y /// I didn't want to display four digits in a circle, so our highest possible maximum is 50 * 19 = 950
            let newXYZ = XYZ(x: x, y: y, z: z)
            xyzs.append(newXYZ)
        }
    }
}

/// if you made it down this far, this handy extension is to easily switch on whether an integer is even or odd
/// (useful for determining what to do with adjacent neighbor calculations)
enum Parity {
    case even, odd

    init<T>(_ integer: T) where T : BinaryInteger {
        self = integer.isMultiple(of: 2) ? .even : .odd
    }
}

extension BinaryInteger {
    var parity: Parity { Parity(self) }
}

//
//  HexGrid.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import Foundation

class HexGrid {

    // brute force set up grid of 19 cells
    let grid: [[HexCell]] =
        [[HexCell(x: 0, y: 0), HexCell(x: 1, y: 0), HexCell(x: 2, y: 0)],
         [HexCell(x: 0, y: 1), HexCell(x: 1, y: 1), HexCell(x: 2, y: 1), HexCell(x: 3, y: 1)],
         [HexCell(x: 0, y: 2), HexCell(x: 1, y: 2), HexCell(x: 2, y: 2), HexCell(x: 3, y: 2), HexCell(x: 4, y: 2)],
         [HexCell(x: 0, y: 3), HexCell(x: 1, y: 3), HexCell(x: 2, y: 3), HexCell(x: 3, y: 3)],
         [HexCell(x: 0, y: 4), HexCell(x: 1, y: 4), HexCell(x: 2, y: 4)]]

    lazy var flattenedGrid: [HexCell] = {
        let flattenedGrid = Array(grid.joined())
        return flattenedGrid
    }()

    init() {
        setUpAdjacentCells()
    }

    func getCellWithCoordinate(x: Int, y: Int) -> HexCell? {
        return flattenedGrid.first(where: { $0.x == x && $0.y == y })
    }
    
    func setUpAdjacentCells() {
        for cell in flattenedGrid {
            var adjacentCells = [HexCell]()
            let x = cell.x
            let y = cell.y

            if let topLeftCell = getCellWithCoordinate(x: x-1, y: y-1) {
                adjacentCells.append(topLeftCell)
            }

            if let topRightCell = getCellWithCoordinate(x: x+1, y: y-1) {
                adjacentCells.append(topRightCell)
            }

            if let leftCell = getCellWithCoordinate(x: x-1, y: y) {
                adjacentCells.append(leftCell)
            }

            if let rightCell = getCellWithCoordinate(x: x+1, y: y) {
                adjacentCells.append(rightCell)
            }

            if let bottomLeftCell = getCellWithCoordinate(x: x, y: y+1) {
                adjacentCells.append(bottomLeftCell)
            }

            if let bottomRightCell = getCellWithCoordinate(x: x+1, y: y+1) {
                adjacentCells.append(bottomRightCell)
            }
            
            cell.adjacentCells = adjacentCells
            Swift.print("cell x \(cell.x) & y \(cell.y) has \(adjacentCells.count) adjacentCells \(adjacentCells)")
        }
    }

    func assignZs(triplets: [Triplet]) {
        
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
                    for potentialCell in zCellAdjacentCells {
                        Swift.print("checking \(potentialCell.x) \(potentialCell.y) placedX \(placedX) placedY \(placedY)")
                        if potentialCell.value == 0 {
                            if placedX == false {
                                potentialCell.value = eachTriplet.x
                                placedX = true
                                Swift.print("placed x \(eachTriplet.x) into \(potentialCell.x) \(potentialCell.y)")
                            } else if placedY == false {
                                potentialCell.value = eachTriplet.y
                                placedY = true
                                Swift.print("placed y \(eachTriplet.y) into \(potentialCell.x) \(potentialCell.y)")
                            }
                        }
                    }
                    if placedX == false && placedY == false {
                        Swift.print("THIS SHOULDN't HAPPEN")
                    }
                    
                    if placedX == true && placedY == true {
                        Swift.print("placed z \(eachTriplet.z) into \(zCell.x) \(zCell.y)")
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

class RandomCellsToCheck {

}

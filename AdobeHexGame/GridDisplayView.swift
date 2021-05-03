//
//  GridDisplayView.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 5/2/21.
//

// A simple class to display values from the HexGrid in an attractive view
// so I can move forward with an interview 

import UIKit

class GridDisplayView: UIView {
    /// IBOutletCollection!
    @IBOutlet var gridCircleView: [CircleDrawView]!
    // more colors here than there will be triplets
    var colors: [UIColor] = [.green, .blue, .orange, .cyan, .brown, .magenta, .red, .purple].shuffled()
    
    func updateGridDisplay(from grid: [HexCell]) {
        for (index,eachCircle) in grid.enumerated() {
            let circleView = gridCircleView[index]
            circleView.title.text = String(eachCircle.value)
            circleView.fillColor = colors[eachCircle.tripletIndex]
            circleView.setNeedsDisplay()
        }
    }
}

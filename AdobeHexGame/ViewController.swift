//
//  ViewController.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let randomTriplets = CreateRandomTriplets()
        let grid = HexGrid()
        grid.assignZs(triplets: randomTriplets.triplets)
    }


}


//
//  ViewController.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gridDisplayView: GridDisplayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    override func viewDidAppear(_ animated: Bool) {
        let randoms = CreateRandomXYZ()
        let grid = HexGrid(gridDisplayView: gridDisplayView)
        let tripletArray = grid.reserveTiles()
        grid.allocateRandoms(with: randoms, into: tripletArray)
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .landscape
    }
}

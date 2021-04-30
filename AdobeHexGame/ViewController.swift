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
        let randoms = CreateRandomTriplets()
        let grid = HexGrid()
    }


}


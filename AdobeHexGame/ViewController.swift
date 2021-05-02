//
//  ViewController.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 4/27/21.
//

import UIKit

@IBDesignable
class CircleDrawView: UIView {

//    @IBInspectable var borderColor: UIColor = UIColor.red
//
//    @IBInspectable var borderSize: CGFloat = 4

    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var fontColor: UIColor = UIColor.white

    func addLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        //label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Hi"
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.textColor = fontColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addLabel()
    }

    override func draw(_ rect: CGRect)
    {
//        layer.borderColor = borderColor.cgColor
//        layer.borderWidth = borderSize
        layer.cornerRadius = self.frame.height/2
        layer.backgroundColor = fillColor.cgColor
    }

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    override func viewDidAppear(_ animated: Bool) {
        let randomTriplets = CreateRandomTriplets()
        let grid = HexGrid()
        grid.assignZs(triplets: randomTriplets.triplets)
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .landscape
    }


}


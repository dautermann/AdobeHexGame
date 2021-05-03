//
//  CircleDrawView.swift
//  AdobeHexGame
//
//  Created by Michael Dautermann on 5/2/21.
//

import UIKit

/// this code comes via https://stackoverflow.com/a/54620679/981049
@IBDesignable
class CircleDrawView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.clear

    @IBInspectable var borderSize: CGFloat = 0

    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var fontColor: UIColor = UIColor.white
    var title: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    func addLabel() {
        self.addSubview(title)
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.textColor = fontColor
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
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderSize
        layer.cornerRadius = self.frame.height/2
        layer.backgroundColor = fillColor.cgColor
    }

}

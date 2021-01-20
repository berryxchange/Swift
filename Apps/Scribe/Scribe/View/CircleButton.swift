//
//  CircleButton.swift
//  Scribe
//
//  Created by Quinton Quaye on 1/23/19.
//  Copyright © 2019 Quinton Quaye. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 30.0 {
       //for using @IBInspectable you will need to use the setting feature to update the UI when data changes.
        didSet{
            setupView()        }
    }

    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
    }
}

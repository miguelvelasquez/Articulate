//
//  CircleButton.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 4/25/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius

    }
}

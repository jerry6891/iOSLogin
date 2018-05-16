//
//  RoundButton.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-04-23.
//  Copyright © 2018 GWEB. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var roundButton:Bool = false {
        didSet{
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    override func prepareForInterfaceBuilder() {
        if roundButton{
            layer.cornerRadius = frame.height / 2
        }
    }
}

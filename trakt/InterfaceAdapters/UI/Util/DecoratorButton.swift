//
//  DecoratorButton.swift
//  ColturViajes
//
//  Created by Lab Positiva Dev on 11/6/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

class DecoratorButton: NSObject {

    class func decorateShadowButton(button: UIButton?) {
        
        button?.layer.shadowColor = UIColor.black.cgColor
        button?.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button?.layer.masksToBounds = false
        button?.layer.shadowRadius = 2.0
        button?.layer.shadowOpacity = 0.2
        button?.layer.cornerRadius = 25
        button?.layer.borderColor = UIColor.black.cgColor
        button?.layer.borderWidth = 0.0
    }
}

//
//  CustomTextField.swift
//  ColturViajes
//
//  Created by roni shender on 11/7/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    @IBInspectable var insetPlaceholder: CGPoint = CGPoint.zero
    @IBInspectable var insetEditText: CGPoint = CGPoint.zero
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: self.insetPlaceholder.x, dy: self.insetPlaceholder.y)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: self.insetEditText.x, dy: self.insetEditText.y)
    }
}

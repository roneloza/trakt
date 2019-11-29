//
//  DispatcherController.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

protocol DispatcherController {
    
    func dispatchOnMainQueue(block: @escaping () -> Void)
    func dispatchOnMainQueue(delay: TimeInterval, block: @escaping () -> Void)
}

extension DispatcherController {
    
    func dispatchOnMainQueue(block: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            block()
        }
    }
    
    func dispatchOnMainQueue(delay: TimeInterval, block: @escaping () -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            block()
        }
    }
}

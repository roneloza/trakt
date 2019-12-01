//
//  ProgressLoaderController.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import SVProgressHUD

protocol ProgressLoaderController: DispatcherController where Self: UIViewController {
    
    func showProgress()
    func dismissProgress()
}

extension ProgressLoaderController {
    
    func showProgress() {
        
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        self.dispatchOnMainQueue {
            
            SVProgressHUD.show()
        }
    }
    
    func dismissProgress() {
        
        self.dispatchOnMainQueue {
         
            SVProgressHUD.dismiss()
        }
    }
}

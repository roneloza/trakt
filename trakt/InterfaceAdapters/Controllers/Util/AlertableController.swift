//
//  AlertableController.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit
import PMAlertController

enum AlertStyle {
    
    case `default`
    case walkthroughAlert
    case sheet
}

enum AlertActionStyle {
    
    case `default`
    case cancel
    case destructive
}

class AlertAction {
    
    var title: String
    var style: AlertActionStyle
    var action: (() -> ())?
    
    init(title: String, style: AlertActionStyle, action: (() -> ())?) {
        
        self.title = title
        self.style = style
        self.action = action
    }
}

class AlertModel {
    
    internal init(title: String?, message: String?, actions: [AlertAction]?, preferredStyle: AlertStyle) {
        self.title = title
        self.message = message
        self.actions = actions
        self.preferredStyle = preferredStyle
    }
    
    var title: String?
    var message: String?
    var actions: [AlertAction]?
    var preferredStyle: AlertStyle
    
}

protocol AlertableController: DispatcherController where Self: UIViewController {
    
    func showAlert(error: CustomError, handler: (() -> ())?)
    func showAlert(model: AlertModel, image: UIImage?, controller: UIViewController?)
    func showAcceptAlert(title: String, message: String, acceptAction:(() -> ())?, image: UIImage?, controller: UIViewController?)
}

extension AlertableController {
    
    func showAlert(error: CustomError, handler: (() -> ())?) {
        
        let message = "\(error.message ?? "")\(error.code?.description ?? "")"
        
        let model = AlertModel(title: error.title, message: message, actions: [AlertAction(title: "Aceptar", style: .default, action: handler)], preferredStyle: .default)
        
        self.showAlert(model: model, image: nil, controller: nil)
    }
    
    func showAlert(model: AlertModel, image: UIImage?, controller: UIViewController?) {
        
        self.dispatchOnMainQueue { [weak self] in
            
            let alertActions = model.actions?.map { (e) -> PMAlertAction in
                
                return PMAlertAction(title: e.title, style: (e.style == AlertActionStyle.default ? PMAlertActionStyle.default : (e.style == AlertActionStyle.cancel ? PMAlertActionStyle.cancel : PMAlertActionStyle.default)), action: (e.action != nil ? {
                    
                    e.action?()
                    
                    } : nil))
            }
            
            let alertVC = PMAlertController(title: model.title, description: model.message, image: image, style: (model.preferredStyle == AlertStyle.default ? PMAlertControllerStyle.alert : (model.preferredStyle == AlertStyle.walkthroughAlert ? PMAlertControllerStyle.walkthrough : PMAlertControllerStyle.alert)))
            
            alertActions?.forEach({ (action) in
                
                alertVC.addAction(action)
            })
            
            //        alertVC.addTextField { (textField) in
            //            textField?.placeholder = "Location..."
            //        }
            
            self?.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showAcceptAlert(title: String, message: String, acceptAction:(() -> ())?, image: UIImage?, controller: UIViewController?) {
        
        let model = AlertModel(title: title, message: message, actions: [AlertAction(title: "Aceptar", style: .default, action: acceptAction)], preferredStyle: .default)
        
        self.showAlert(model: model, image: image, controller: controller)
    }
}

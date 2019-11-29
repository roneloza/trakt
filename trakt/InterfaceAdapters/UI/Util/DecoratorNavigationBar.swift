//
//  DecoratorNavigationBar.swift
//  ColturViajes
//
//  Created by roni shender on 11/8/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

protocol DecoratorNavigationBar where Self: UIViewController {

    func decorateNavigationBar()
}

extension DecoratorNavigationBar {
    
    func decorateNavigationBar() {
        
        self.navigationController?.navigationBar.barStyle = .black
        //        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 20)!]
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .black
    }
}

protocol DecoratorNavigationBarReservesList: DecoratorNavigationBar {
    
}

extension DecoratorNavigationBarReservesList {
    
    func decorateNavigationBar() {
        
        self.navigationController?.navigationBar.barStyle = .default
//        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 20)!]

        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
    }
}

protocol DecoratorNavigationBarReserveDetail: DecoratorNavigationBar {
    
}

extension DecoratorNavigationBarReserveDetail {
    
    func decorateNavigationBar() {  
        
        self.navigationController?.navigationBar.barStyle = .black
//        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 20)!]

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .black
    }
}

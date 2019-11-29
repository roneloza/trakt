//
//  BaseViewController.swift
//  ColturViajes
//
//  Created by roni shender on 11/7/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    internal let userDataStore: AppUserDataStore = AppUserDataStandarDefaults()
    
    var navigationBarHidden: Bool {
        
        get {
        
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(self.navigationBarHidden, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.settingNavigationBar()
    }

    func settingNavigationBar() {

    }
    
    func handleWebServiceError(error: CustomError) {
        
        if let code = error.code {
            
            switch code {
                
            case RestWebServiceStatusCode.unauthorised.rawValue :
                
                self.handleUnAauthorization()
            default:
                ()
            }
        }
    }
    
    func handleUnAauthorization() {
        
        self.userDataStore.removeObject(key: AppUserDataStoreKeys.loginDataUser.rawValue)
        
        if let rootViewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {

            UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("deinit %@", self)
    }

}

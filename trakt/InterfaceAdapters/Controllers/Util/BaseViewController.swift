//
//  BaseViewController.swift
//  ColturViajes
//
//  Created by roni shender on 11/7/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

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
    
    //MARK: - UI -
    
    func playVideo(key: String) {
        
        let playerViewController = AVPlayerViewController()
        
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(key) { (video, error) in
            
            if let streamURL = video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] {
                
                playerViewController.player = AVPlayer(url: streamURL)
                playerViewController.player?.play()
            }
            else {
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        print("deinit %@", self)
    }

}

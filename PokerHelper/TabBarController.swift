//
//  TabBarController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/11/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

//import SwipeableTabBarController

//class TabBarController: SwipeableTabBarController {
//    // Do all your subclassing as a regular UITabBarController.
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        selectedViewController = viewControllers?[0]
////        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
////        setSwipeAnimation(type: SwipeAnimationType.push)
//    }
//}

import UIKit
import LFLoginController
import SwiftyJSON

class TabBarController: UITabBarController {
    // Do all your subclassing as a regular UITabBarController.
    let loginController = LFLoginController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedViewController = viewControllers?[0]
        //        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        //        setSwipeAnimation(type: SwipeAnimationType.push)
        loginController.delegate = (self as LFLoginControllerDelegate)
        // Customizations
        loginController.logo = UIImage(named: "AwesomeLabsLogoWhite")
        self.present(loginController, animated: false, completion: {})
    }
    
    func processLoginMessage(message: String) {
        let json = JSON.init(parseJSON: message)
        let username = json["username"].stringValue
//        let password = json["password"].stringValue
        let error = json["error"].stringValue
        if !error.isEmpty {
            print("\(error)")
            loginController.wrongInfoShake()
        } else {
            let tableController = self.childViewControllers[0].childViewControllers[0] as! TableController
            tableController.loadGame(username: username)
            self.presentedViewController?.dismiss(animated: true, completion: {})
        }
    }
    
    func processSignupMessage(message: String) {
        let json = JSON.init(parseJSON: message)
        let error = json["error"].stringValue
        if !error.isEmpty {
            print("\(error)")
            loginController.wrongInfoShake()
        } else {
            self.presentedViewController?.dismiss(animated: true, completion: {})
        }
    }
}

extension TabBarController: LFLoginControllerDelegate {
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
        
        // Implement your server call here
        var json = JSON()
        json["username"].string = email
        json["password"].string = password.sha256()
        
        if type == LFLoginController.SendType.Login {
            Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "login", json: json), using: appDelegate.client!, completion: processLoginMessage)
        }
        else {
            // sign up
            json["date"].string = Util.dateNowAsString()
            Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "signup", json: json), using: appDelegate.client!, completion: processSignupMessage)
        }

        print(email)
        print(password)
        print(type)
    }
    
    func forgotPasswordTapped(email: String) {
        print("forgot password: \(email)")
    }
}

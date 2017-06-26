//
//  ViewController.swift
//  LFLoginController
//
//  Created by Lucas Farah on 6/10/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable trailing_whitespace

import UIKit
import LFLoginController

class LoginController: UIViewController {
    
    let controller = LFLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        
        // Customizations
        controller.logo = UIImage(named: "AwesomeLabsLogoWhite")
        self.navigationController?.pushViewController(controller, animated: false)
//		controller.videoURL = NSBundle.mainBundle().URLForResource("PolarBear", withExtension: "mov")!
//		controller.loginButtonColor = UIColor.purpleColor()
//		controller.setupOnePassword("YourAppName", appUrl: "YourAppURL")
    }
    
//    @IBAction func butLoginTapped(sender: AnyObject) {
//        
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginController: LFLoginControllerDelegate {
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
        
        // Implement your server call here
        
        print(email)
        print(password)
        print(type)
        
        // Example
//        if type == .Login && password != "1234" {
        if (false) {
            
            controller.wrongInfoShake()
        } else {
//            _ = navigationController?.popViewController(animated: true)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            tabBarController.navigationItem.setHidesBackButton(true, animated:true);
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
    
    func forgotPasswordTapped() {
//        print("forgot password: \(email)")
    }
}

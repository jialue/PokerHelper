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
import SwiftSocket

class LoginController: UIViewController {
    
    let controller = LFLoginController()
    var client = (UIApplication.shared.delegate as! AppDelegate).client
    
    func processLoginService(message: String) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        
        // Customizations
        controller.logo = UIImage(named: "AwesomeLabsLogoWhite")
        self.navigationController?.pushViewController(controller, animated: false)
        
        // login message
        let request = Util.HttpRequest(method: "GET", requestURI: "/login", jsonString: "{\"username\": \"25\"}")
        Util.ServerUtil.sendRequest(string: request.generatHttpRequest(), using: client!, completion: processLoginService)
        
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
    public func forgotPasswordTapped(email: String) {
        
    }

    
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

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
class TabBarController: UITabBarController {
    // Do all your subclassing as a regular UITabBarController.
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedViewController = viewControllers?[0]
        //        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        //        setSwipeAnimation(type: SwipeAnimationType.push)
    }
}

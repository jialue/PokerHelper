//
//  NewGameController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/11/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import UIKit
import CoreData

class NewGameController: UIViewController, UITextFieldDelegate {
//    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var ratioText: UITextField!
    @IBOutlet weak var smallBlindText: UITextField!
    @IBOutlet weak var bigBlindText: UITextField!
    @IBOutlet weak var stackText: UITextField!
    
    var table: TableController?
    var defaultStack = Int(0)
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func Create(_ sender: Any) {
        // Check inpouts if fail, return
        if ratioText.text == "" {
            ratioText.text = "0.1"
        }
        if smallBlindText.text == "" {
            smallBlindText.text = "1";
        }
        if bigBlindText.text == "" {
            bigBlindText.text = "2";
        }
        if stackText.text == "" {
            stackText.text = "200";
        }
        let gameData = dataController.create(entityName: "GameData") as! GameData
        gameData.ratio = Float(ratioText.text!)!
        gameData.smallblind = Int32(smallBlindText.text!)!
        gameData.bigblind = Int32(bigBlindText.text!)!
        gameData.date = NSDate()
        defaultStack = Int(stackText.text!)!
        table?.games.append(gameData)
        table?.tableView.reloadData()
        dataController.save()
        self.dismiss(animated: true, completion: {});
    }

    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }

}

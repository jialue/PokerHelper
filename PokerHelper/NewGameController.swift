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
    var table: TableController?
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func Create(_ sender: Any) {
        // Check inpouts if fail, return
        if ratioText.text == "" {
            ratioText.text = "0.1"
        }
//        if playerName.text == nil {
//            playerName.text = "New Player"
//        }
        if smallBlindText.text == "" {
            smallBlindText.text = "1";
        }
        if bigBlindText.text == "" {
            bigBlindText.text = "2";
        }
//        let names = playerName.text?.components(separatedBy: ";")
//        let buyIn = 0
//        let gameData = dataController.create<GameData>(entityName: "GameData")
        let gameData = dataController.create(entityName: "GameData") as! GameData
//        gameData.playerNames = [String]()
//        gameData.playerData = Dictionary<String, Int>()
//        gameData.playerBuyin = Dictionary<String, Int>()
//        for name in names! {
//            if name == "" {
//                continue
//            }
//            gameData.playerNames?.append(name)
//            gameData.playerData?[name] = buyIn
//            gameData.detail = name
//            gameData.buyin += Int64(buyIn);
//        }
        gameData.ratio = Float(ratioText.text!)!
        gameData.smallblind = Int32(smallBlindText.text!)!
        gameData.bigblind = Int32(bigBlindText.text!)!
        gameData.date = NSDate()
//        let game = Game(pokerPlayers: players, ratio: ratio, smallBlind: smallBlind, bigBlind: bigBlind)
        table?.games.append(gameData)
        table?.tableView.reloadData()
        dataController.save()
        self.dismiss(animated: true, completion: {});
    }

    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }

}

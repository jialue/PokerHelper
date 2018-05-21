//
//  NewGameController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/11/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import UIKit
import CoreData
import SwiftSocket

class NewGameController: UIViewController, UITextFieldDelegate {
//    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var ratioText: UITextField!
    @IBOutlet weak var smallBlindText: UITextField!
    @IBOutlet weak var bigBlindText: UITextField!
//    @IBOutlet weak var stackText: UITextField!
    
    var table: TableController?
    var defaultStack = Int(0)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func processGameCreationMessage(message: String) -> Void {
        print("processing \(message)");
        do {
            let game = try Proto_GameData.init(jsonString: message)
            table?.games.append(game)
            table?.tableView.reloadData()
        }
        catch {
            
        }
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

        
        // save to local
        dataController.save()
        
        //TODO send game context to server
//        let factor = 100
        var game = Proto_GameData()
//        game.id = Int32(Date().timeIntervalSince1970)
        game.small = Int32(smallBlindText.text!)!
        game.big = Int32(bigBlindText.text!)!
        game.ratio = Int32(100)    // convert ratio to an integer by mulitplying with a factor
        game.public = true;
        game.owner = 25 // an example owner id, must be a valid user id
        
        // US English Locale (en_US)
        
        game.date = "20180408"
//        let request = Util.HttpRequest(method: "POST", requestURI: "/createGame", requestData: game)
//        Util.ServerUtil.sendRequest(string: request.generatHttpRequest(), using: appDelegate.client!, completion: processGameCreationMessage)
        Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "createGame", jsonString: try!game.jsonString()), using: appDelegate.client!, completion: processGameCreationMessage)

        self.dismiss(animated: true, completion: {});
    }

    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> Int64 {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
//        let strTimeStamp: String = "\(milliseconds)"
        return milliseconds
    }
}

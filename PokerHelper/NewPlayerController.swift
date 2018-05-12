//
//  NewGameController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/11/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewPlayerController: UIViewController {
    
    @IBOutlet weak var playerName: UITextField!
    var table: GameCellTableController?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    override func viewDidLoad() {
        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, forKeyPath:  #selector(NewPlayerController.test), name: "dd", context: dataController.managedObjectContext)
        notificationCenter.addObserver(self, selector: #selector(NewPlayerController.test), name: NSNotification.Name.NSManagedObjectContextDidSave, object: dataController.managedObjectContext)
        super.viewDidLoad()
        
    }
    
    func processAddPlayerMessage(message: String) throws -> Void {
        let j = JSON.init(parseJSON: message)
        if let error = j["error"].string {
            local_error(message: error);
            if error.contains("Duplicate entry") {
                throw GameError.AddPlayerError(error: "Player already exists in the game.")
            }
            else {
                throw GameError.Generic(error: error)
            }
        }
        do {
            let player = try Proto_Player.init(jsonString: message)
            table!.game!.players.append(player)
            table!.tableView.reloadData()
        }
        catch {
            throw GameError.Generic(error: "Unknown Error")
        }
    }
    
    func addPlayer(playerName: String) throws -> Void {
        var json = JSON()
        json["id"].int = table!.id;
        json["game_id"].int32 = table!.game!.id
        json["player_id"].int32 = Int32(playerName)
        json["player_name"].string = playerName
        let request = Util.HttpRequest(method: "POST", requestURI: "/addUserToGame", json: json)
        try Util.ServerUtil.sendRequest(string: request.generatHttpRequest(), using: appDelegate.client!, completion: processAddPlayerMessage)
    }
    
    @IBAction func Create(_ sender: Any) {
        do {
        // Check inpouts if fail, return
        if playerName.text! == "" {
            let alert = UIAlertController(title: "Error", message: "Name cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        let names = playerName.text?.components(separatedBy: ";")
        for name in names! {
            try addPlayer(playerName: name)
        }
        self.dismiss(animated: true, completion: {});
        }
        catch GameError.AddPlayerError(let error) {
            let alert = UIAlertController(title: "Warn", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in

            }))
            present(alert, animated: true, completion: nil)
        }
        catch GameError.Generic(let error) {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                
            }))
            present(alert, animated: true, completion: nil)
        }
        catch {
            local_error()
        }
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }
    
    @objc func test() {
        print("saved")
    }

}

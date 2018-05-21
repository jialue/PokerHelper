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
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, forKeyPath:  #selector(NewPlayerController.test), name: "dd", context: dataController.managedObjectContext)
//        notificationCenter.addObserver(self, selector: #selector(NewPlayerController.test), name: NSNotification.Name.NSManagedObjectContextDidSave, object: dataController.managedObjectContext)
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
    
    func processGameInvitationMessage(message: String) -> Void {
        print("\(message)")
//        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "test"), object: "Hello 2017")
    }
    
    func addPlayer(playerName: String) throws -> Void {
//        var message = JSON()
        var json = JSON()
        json["id"].int = table!.id;
        json["game_id"].int32 = table!.game!.id
        json["player_id"].int32 = Int32(playerName)
        json["player_name"].string = playerName
//        json["message"].object = message
        try Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "addUserToGame", json: json), using: appDelegate.client!, completion: processAddPlayerMessage)
    }
    
    func invitePlayer(playerName: String) -> Void {
//        var message = JSON()
        var json = JSON()
        json["id"].int = table!.id;
        json["game_id"].int32 = table!.game!.id
//        message["player_id"].int32 = Int32(playerName)
        var name = JSON();
        name["name"].string = playerName
        json["player_name_array"].arrayObject?.append(name)
//        json["message"].object = message
        Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "inviteUser", json: json), using: appDelegate.client!, completion: processGameInvitationMessage)
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
//            try addPlayer(playerName: name)
            invitePlayer(playerName: name)
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

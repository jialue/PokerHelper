//
//  TableViewController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/11/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import UIKit
import CoreData
import SwiftSocket
import SwiftyJSON

class TableController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var games = [Proto_GameData]()
    var cellGame: Proto_GameData?
    var dataController : DataController?
    
    public func loadGame(username: String) {
        Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "loadGame", jsonString: "{\"username\":\"\(username)\"}"), using: appDelegate.client!, completion: processGetGameReponse)
    }

    func processGetGameReponse(message: String) {
        print("\(message)")
        do {
            try games = Proto_GameData.array(fromJSONString: message)
            tableView.reloadData()
        }
        catch {
            print("error");
        }
    }
    
    func processLoginMessage(message: String) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "login", jsonString: "{\"username\":\"jialue\"}"), using: appDelegate.client!, completion: processLoginMessage)
//        Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "loadGame", jsonString: "{\"username\":\"jialue\"}"), using: appDelegate.client!, completion: processGetGameReponse)
    
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
//        return games.count
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
        let game = games[indexPath.row]
        let id = String(game.id)
        cell.textLabel?.text = "Game \(id)"
        cell.detailTextLabel?.text = game.date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellGame = games[indexPath.row]
        performSegue(withIdentifier: "segueToGameCell", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete game from DB
            var data = Proto_GameData();
//            data.id = games[indexPath.row]
            let game = games[indexPath.row]
            data.id = game.id
            let request = Util.HttpRequest(method: "POST", requestURI: "/deleteGame", requestData: data)
            Util.ServerUtil.sendRequest(string: request.generatHttpRequest(), using: appDelegate.client!)
//            Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "deleteGame", jsonString: try!data.jsonString()), using: appDelegate.client!, completion:()->Void{})
            
            // remove the item from the data model
//            appDelegate.dataController.delete(object: games[indexPath.row])
//            appDelegate.dataController.save()
            games.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToNewGame") {
            let vc = segue.destination as! UINavigationController
            let game = vc.viewControllers[0] as! NewGameController
            game.table = self
//            game.games = games
        }
        if (segue.identifier == "segueToGameCell") {
            let gameCellTable = segue.destination as! GameCellTableController
//            let vc = segue.destination as! UINavigationController
//            let gameCellTable = vc.viewControllers[0] as! GameCellTableController
//            gameCellTable.game = cellGame
            gameCellTable.game = cellGame
        }
    }
    
    @IBAction func sendButtonAction() {
        switch appDelegate.client!.connect(timeout: 10) {
        case .success:
            print("Connected to host \(appDelegate.client!.address)")
//            Util.ServerUtil.sendRequest(string: "GET /hello HTTP/1.1\r\n\r\n", using: appDelegate.client!)
            
            var data = Proto_GameData();
            data.big = 1111;
            data.buyin = 2222;
            data.date = "20180408"
//            data.date.day = "25";
//            data.date.month = "11";
//            data.date.year = "2017";
            
//            let jsonString: String = try! data.jsonString()
//            let json = try! Proto_GameData(jsonString: jsonString)
//            let request = Util.HttpRequest(method: "POST", requestURI: "/createGame", requestData: data)
//            Util.ServerUtil.sendRequest(string: request.generatHttpRequest(), using: appDelegate.client!)
            Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "loadGame", jsonString: "{\"id\":25}"), using: appDelegate.client!, completion: processGetGameReponse)
            
            
        case .failure(let error):
            print(String(describing: error))
        }
        
//        guard let client = client else { return }
//        
//        switch client.connect(timeout: 10) {
//        case .success:
//            appendToTextField(string: "Connected to host \(client.address)")
//            if let response = sendRequest(string: "GET /hello HTTP/1.0\r\n\r\n", using: client) {
//                appendToTextField(string: "Response: \(response)")
//            }
//        case .failure(let error):
//            appendToTextField(string: String(describing: error))
//        }
    }
}

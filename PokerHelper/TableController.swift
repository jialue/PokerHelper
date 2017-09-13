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

class TableController: UITableViewController {
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    var games = [GameData]()
    var cellGame: GameData?
    
    // server info
    let host = "127.0.0.1"
    let port = 8081
    var client: TCPClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Game List"
        games = dataController.fetch(entityName: "GameData") as! [GameData]
        
        // server connect
        client = TCPClient(address: host, port: Int32(port))
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
        let game = games[indexPath.row]
        let detail = game.detail
        let date = game.date as! Date
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        let time = dateformatter.string(from: date)
        cell.textLabel?.text = detail
        cell.detailTextLabel?.text = time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellGame = games[indexPath.row]
        performSegue(withIdentifier: "segueToGameCell", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove the item from the data model
            dataController.delete(object: games[indexPath.row])
            dataController.save()
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
            gameCellTable.game = cellGame
        }
    }
    
    @IBAction func sendButtonAction() {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            if let response = sendRequest(string: "GET /hello HTTP/1.0\r\n\r\n", using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }
    }
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        appendToTextField(string: "Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            appendToTextField(string: String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*10, timeout:10) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    private func appendToTextField(string: String) {
        print(string)
    }
}

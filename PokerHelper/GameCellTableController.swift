//
//  GameTableController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/12/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftyJSON

class GameCellTableController: UITableViewController {
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
//    var game : GameData?
    var game : Proto_GameData?
//    var players = [Proto_Player]()
    var userInput : String?
    
    let username = "jialue"
    let id = 19
    
    func processGameDetailMessage(message: String) {
        print("\(message)")
        do {
            game!.players = try Proto_Player.array(fromJSONString: message)
        }
        catch {
            local_error()
        }
    }
    
    override func viewDidLoad() {
//        let json: JSON = ["id":25]
//        json["id"] = 25
//        let request = Util.HttpRequest(method: "GET", requestURI: "/getGameDetail", jsonString: "{\"id\":\(game!.id)}")
//        Util.ServerUtil.sendRequest(string: request.generatHttpRequest(), using: appDelegate.client!, completion: processGameDetailMessage)
        Util.ServerUtil.sendRequest(request: Util.DealerServerRequest.init(service: "getGameDetail", jsonString: "{\"id\":\(game!.id)}"), using: appDelegate.client!, completion: processGameDetailMessage)
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return game!.players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell
        let player = game!.players[indexPath.row]
        let name = player.nickname
        let buyin = player.buyin
        let stack = player.stack
        cell.textLabel!.text = "\(player.id)" + name + "(\(buyin))"
        if (false) {
            let balance = (Float)(stack - buyin) * Float(game!.ratio)
            cell.detailTextLabel?.text = "Balance: $\(balance)"
        }
        else {
            cell.detailTextLabel?.text = "Stack: \(stack)"
        }
//        cell.buyButton.tag = indexPath.row
//        cell.buyButton.addTarget(self, action: #selector(buy(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let update = UITableViewRowAction(style: .normal, title: "UPDATE") { action, index in
            let alert = UIAlertController(title: "Current Total Chips", message: "Enter a number", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                if textField?.text == "" {
                    return;
                }
                let player = self.game!.players[editActionsForRowAt.row]
                let name = player.nickname
                let stack = Int32((textField?.text!)!)!
//                self.game?.playerData?[name!] = chips
                self.game!.players[editActionsForRowAt.row].stack = stack;
                self.dataController.save()
                self.updateCell(cellIndex: editActionsForRowAt, buyin: player.buyin, stack: player.stack)
                print("Player \(String(describing: name)) now has \(stack) chips")
                
                //TODO update info
                
//                self.dataController.save()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        update.backgroundColor = .lightGray
        let buyin = UITableViewRowAction(style: .normal, title: "BUYIN") { action, index in
            let alert = UIAlertController(title: "Final Total Chips", message: "Enter a number", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                if textField?.text == "" {
                    return;
                }
                // TODO 
//                let name = self.game?.playerNames?[editActionsForRowAt.row]
//                let chips = Int((textField?.text!)!)!
//                self.game?.playerData?[name!]! += chips
//                self.game?.buyin += Int64(chips)
//                self.game?.playerBuyin?[name!]! += chips;
//                self.dataController.save()
//                self.updateCell(cellIndex: editActionsForRowAt, buyin: (self.game?.playerBuyin?[name!]), stack: (self.game?.playerData?[name!])!)
//                print("Player \(String(describing: name)) buy \(chips) chips.")
//                self.dataController.save()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        buyin.backgroundColor = .darkGray
        
        let cashout = UITableViewRowAction(style: .normal, title: "CASHOUT") { action, index in
            let alert = UIAlertController(title: "Cash out", message: "Enter a number", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                if textField?.text == "" {
                    return;
                }
//                let name = self.game?.playerNames?[editActionsForRowAt.row]
//                let chips = Int((textField?.text!)!)!
//                self.game?.playerData?[name!]! -= chips
//                self.game?.buyin -= Int64(chips)
//                self.game?.playerBuyin?[name!]! -= chips;
//                self.dataController.save()
////                self.updateCell(cellIndex: editActionsForRowAt, buyin: (self.game?.playerBuyin?[name!])!, stack: (self.game?.playerData?[name!])!)
//                print("Player \(String(describing: name)) cash out \(chips) chips")
//                self.dataController.save()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        buyin.backgroundColor = .darkGray
        return [update, buyin, cashout]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let name = game?.playerNames?[indexPath.row]
//        game?.playerData?[name!]? += 500
//        game?.buyin += 500
//        dataController.save()
//        tableView.reloadData()
    }
    
    @IBAction func endGame(_ sender: Any) {
        // check if chips sum is zero
        var sum = Int32()
//        for name in (game?.playerNames)! {
//            sum += (game?.playerData?[name])!
//        }
        for player in game!.players {
            sum += player.stack
        }
        var alert : UIAlertController?
        if (sum == game!.stack) {
            alert = UIAlertController(title: "Correct", message: "Chip sum is \(sum).", preferredStyle: .alert)
//            game!.end = true
        }
        else {
            alert = UIAlertController(title: "Wrong", message: "Chip sum is \(sum), Buy in sum is \(self.game!.buyin), please check your chips.", preferredStyle: .alert)
//            game?.end = false
        }
//        dataController.save();
        alert?.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in}))
        self.present(alert!, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    
    @objc func buy(sender: UIButton) {
//        game?.players[sender.tag].buyIn(chips: 500)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToNewPlayer") {
            let vc = segue.destination as! UINavigationController
            let player = vc.viewControllers[0] as! NewPlayerController
            player.table = self
        }
    }
    
    func updateCell(cellIndex: IndexPath, buyin: Int32, stack: Int32) {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: cellIndex) as! PlayerCell
//        let name = game?.playerNames?[cellIndex.row]
        let name = game!.players[cellIndex.row].nickname
        cell.textLabel!.text = name + "(\(String(buyin)))"
//        if (game?.end)! {
        if (false) {
            let balance = (Float)(stack - buyin) * (Float)(game!.ratio)
            cell.detailTextLabel?.text = "Balance: $\(balance)"
        }
        else {
            cell.detailTextLabel?.text = "Chips: \(String(stack))"
        }
        tableView.reloadData()  // Add this line just in case, not sure if needed
        tableView.reloadRows(at: [cellIndex], with: .automatic)
    }
    
    func loadCell(cellIndex: IndexPath, playerName: String) {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: cellIndex) as! PlayerCell
//        let name = game?.playerNames?[cellIndex.row]
//        let buyin = game?.playerBuyin?[name!]
//        let stack = game?.playerData?[name!]!
        let player = game!.players[cellIndex.row]
        let name = player.nickname
        let buyin = player.buyin
        let stack  = player.stack
        cell.textLabel!.text = name + "(\(buyin))"
//        if (game?.end)! {
        if (false) {
            let balance = (Float)(stack - buyin) * (Float)(game!.ratio)
            cell.detailTextLabel?.text = "Balance: $\(balance)"
        }
        else {
            cell.detailTextLabel?.text = "Chips: \(stack)"
        }
    }
}

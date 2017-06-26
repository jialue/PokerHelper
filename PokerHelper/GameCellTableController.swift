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

class GameCellTableController: UITableViewController {
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    var game : GameData?
    var userInput : String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return (game?.playerNames?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell
        let name = game?.playerNames?[indexPath.row]
        let buyin = game?.playerBuyin?[name!]
        let chips = game?.playerData?[name!]!
        cell.textLabel!.text = name! + "(\(buyin!))"
        if (game?.end)! {
            let balance = (Float)(chips! - buyin!) * (game?.ratio)!
            cell.detailTextLabel?.text = "Balance: $\(balance)"
        }
        else {
            cell.detailTextLabel?.text = "Chips: \(chips!)"
        }
        cell.buyButton.tag = indexPath.row
        cell.buyButton.addTarget(self, action: #selector(buy(sender:)), for: .touchUpInside)
        
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
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: editActionsForRowAt) as! PlayerCell
                
                let name = self.game?.playerNames?[editActionsForRowAt.row]
                let chips = Int((textField?.text!)!)!
                self.game?.playerData?[name!] = chips
                self.dataController.save()
                cell.detailTextLabel?.text = textField?.text
                tableView.reloadData()
//                print("Player \(name) cashout \(player!.finalChips) chips")
                print("Player \(String(describing: name)) now has \(chips) chips")
                self.dataController.save()
            }))
            self.present(alert, animated: true, completion: nil)
//            tableView.setEditing(false, animated: true)
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
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: editActionsForRowAt) as! PlayerCell
                let name = self.game?.playerNames?[editActionsForRowAt.row]
                let chips = Int((textField?.text!)!)!
                self.game?.playerData?[name!]! += chips
                self.game?.buyin += chips
                self.game?.playerBuyin?[name!]! += chips;
                self.dataController.save()
                cell.detailTextLabel?.text = textField?.text
                tableView.reloadData()
                print("Player \(String(describing: name)) buy \(chips) chips")
                self.dataController.save()
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
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: editActionsForRowAt) as! PlayerCell
                let name = self.game?.playerNames?[editActionsForRowAt.row]
                let chips = Int((textField?.text!)!)!
                self.game?.playerData?[name!]! -= chips
                self.game?.buyin -= chips
                self.game?.playerBuyin?[name!]! -= chips;
                self.dataController.save()
                cell.detailTextLabel?.text = textField?.text
                tableView.reloadData()
                print("Player \(String(describing: name)) cash out \(chips) chips")
                self.dataController.save()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        buyin.backgroundColor = .darkGray
        return [update, buyin, cashout]
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            NSLog("%s", "delete this row")
//        }
//        else {
//            let cell = self.tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell
//            cell.detailTextLabel?.text = userInput
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let name = game?.playerNames?[indexPath.row]
//        game?.playerData?[name!]? += 500
//        game?.buyin += 500
//        dataController.save()
//        tableView.reloadData()
    }
    
    @IBAction func endGame(_ sender: Any) {
        // check if chips sum is zero
        var sum = Int(0)
        for name in (game?.playerNames)! {
            sum += (game?.playerData?[name])!
        }
        var alert : UIAlertController?
        if (sum == (Int)((game?.buyin)!)) {
            alert = UIAlertController(title: "Correct", message: "Chip sum is \(sum).", preferredStyle: .alert)
            game?.end = true
        }
        else {
            alert = UIAlertController(title: "Wrong", message: "Chip sum is \(sum), Buy in sum is \((Int)((game?.buyin)!)), please check your chips.", preferredStyle: .alert)
            game?.end = false
        }
        dataController.save();
        alert?.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in}))
        self.present(alert!, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    
    func buy(sender: UIButton) {
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
}

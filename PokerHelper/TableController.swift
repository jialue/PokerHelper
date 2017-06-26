//
//  TableViewController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/11/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import UIKit
import CoreData

class TableController: UITableViewController {
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    var games = [GameData]()
    var cellGame: GameData?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Game List"
        games = dataController.fetch(entityName: "GameData") as! [GameData]
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
        // Get Cell Label
//        let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! GameCell
//        cellGame = cell.game
        cellGame = games[indexPath.row]
        performSegue(withIdentifier: "segueToGameCell", sender: self)
        
    }
    
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
    
//        let cashout = UITableViewRowAction(style: .destructive, title: "End") { action, index in
//            let alert = UIAlertController(title: "Do you want to end this game?", message: "", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "End", style: .default, handler: { [weak alert] (_) in
//                let cell = self.games[editActionsForRowAt.row]
//                self.dataController.delete(object: cell)
//                self.dataController.save()
//            }))
////            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in}))
//            self.present(alert, animated: true, completion: nil)
//        }
//        cashout.backgroundColor = .lightGray
//        return [cashout]
        
//    }
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
}

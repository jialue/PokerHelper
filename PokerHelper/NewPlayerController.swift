//
//  NewGameController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/11/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import UIKit

class NewPlayerController: UIViewController {
    
    @IBOutlet weak var playerName: UITextField!
    var table: GameCellTableController?
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func Create(_ sender: Any) {
        // Check inpouts if fail, return
        if playerName.text == "" {
            let alert = UIAlertController(title: "Error", message: "Name cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                
            }))
            present(alert, animated: true, completion: nil)
            return;
        }
        let names = playerName.text?.components(separatedBy: ";")
        for name in names! {
            table?.game?.addPlayer(playerName: name, chips: 0)
        }
        dataController.save()
        table?.tableView.reloadData()
        self.dismiss(animated: true, completion: {});
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }

}

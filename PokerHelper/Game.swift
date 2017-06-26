//
//  Game.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/12/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import CoreData

class Game: PokerHelperData {
    internal var entityName: String?

    var data: NSManagedObject?
    var players = [Player]()
    let date = Date()
    let dateFormatter = DateFormatter()
    var dateString = String()
    var discription = String("New Game")
    var ratio = float_t()
    var smallBlind = Int()
    var bigBlind = Int()
    init (pokerPlayers: [Player], ratio: float_t, smallBlind: Int, bigBlind: Int) {
        players = pokerPlayers
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateString = dateFormatter.string(from: date)
        
    }
    
    // Creata object and save to Core Data
    static func create(pokerPlayers: [Player], ratio: float_t, smallBlind: Int, bigBlind: Int) -> Game {
        let game = Game(pokerPlayers: pokerPlayers, ratio: ratio, smallBlind: smallBlind, bigBlind: bigBlind)
        game.save()
        return game
    }
    
    // Save to CoreData
    func save() {
//        data.set
    }

    required init(coder decoder: NSCoder) {
        self.players = (decoder.decodeObject(forKey: "players") as? [Player])!
        //        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        //        self.age = decoder.decodeInteger(forKey: "age")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(players, forKey: "players")
        //        coder.encode(name, forKey: "name")
        //        coder.encode(age, forKey: "age")
    }
}

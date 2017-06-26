//
//  Player.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/12/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import CoreData

class Player: PokerHelperData {
//    var data: NSManagedObject?
    let entityName = String("PlayerData")
    var name = String()
    var buyIn = Int()
    var currentChips = Int()
    var finalChips = Int()
    
    init(playerName: String) {
        name = playerName
    }
    
    func buyIn(chips: Int) {
        buyIn += chips
        currentChips += chips
    }
    
    func setChips(chips: Int) {
        currentChips = chips
        finalChips = currentChips - buyIn
    }
    
    required init(coder decoder: NSCoder) {
//        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
//        self.age = decoder.decodeInteger(forKey: "age")
    }
    
    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(age, forKey: "age")
    }
}

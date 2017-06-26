//
//  GameData+CoreDataClass.swift
//  
//
//  Created by Jialue Huang on 3/19/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


public class GameData: NSManagedObject {
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context);
        playerNames = [String]()
        playerData = Dictionary<String, Int>()
        playerBuyin = Dictionary<String, Int>()
        
    }
    func addPlayer(playerName: String, chips: Int) {
        playerNames?.append(playerName)
        playerData?[playerName] = chips
        playerBuyin?[playerName] = chips
        buyin += Int64(chips)
    }
    
    func removePlayer(playerName: String) {
        if let index = playerNames?.index(of: playerName) {
            playerNames?.remove(at: index)
        }
        buyin -= Int64((playerBuyin?[playerName])!)
        playerData?.removeValue(forKey: playerName)
        playerBuyin?.removeValue(forKey: playerName)
    }
}

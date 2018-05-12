//
//  GameData+CoreDataProperties.swift
//  
//
//  Created by Jialue Huang on 25/02/2018.
//
//

import Foundation
import CoreData


extension GameData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameData> {
        return NSFetchRequest<GameData>(entityName: "GameData")
    }

    @NSManaged public var bigblind: Int32
    @NSManaged public var buyin: Int64
    @NSManaged public var date: NSDate?
    @NSManaged public var detail: String?
    @NSManaged public var end: Bool
    @NSManaged public var location: String?
    @NSManaged public var playerBuyin: Dictionary<String, Int>?
    @NSManaged public var playerData: Dictionary<String, Int>?
    @NSManaged public var playerNames: [String]?
    @NSManaged public var ratio: Float
    @NSManaged public var smallblind: Int32
    @NSManaged public var visible: Bool
    @NSManaged public var id: Int64

}

//
//  PlayerData+CoreDataProperties.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/19/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import Foundation
import CoreData


extension PlayerData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerData> {
        return NSFetchRequest<PlayerData>(entityName: "PlayerData");
    }

    @NSManaged public var cash: Double
    @NSManaged public var name: String?
    @NSManaged public var chips: Int64
}

//
//  PlayerData+CoreDataClass.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/19/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import Foundation
import CoreData


public class PlayerData: NSManagedObject {
    func buyIn(chips: Int64) {
        self.chips += chips
    }
}

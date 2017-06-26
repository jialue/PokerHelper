//
//  PokerHelpData.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/19/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import Foundation
import CoreData

protocol PokerHelperData: NSCoding {
    var data: NSManagedObject? {get set}
    var entityName: String? {get}
    func save()
}

extension PokerHelperData {
    func save() {
        data?.setValue(self, forKey: entityName!)
    }
}

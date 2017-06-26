//
//  DataController.swift
//  PokerHelper
//
//  Created by Jialue Huang on 3/15/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import UIKit
import CoreData
class DataController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "PokerHelper", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
        DispatchQueue.global().async {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
//    func create<T>(entityName: String) -> T {
//        let data = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! T
//        return data
//    }
    
    func create(entityName: String) -> NSManagedObject {
        let data = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as NSManagedObject
        return data
    }
    func delete(object: NSManagedObject) {
        managedObjectContext.delete(object)
    }
    func save() {
        do {
            try managedObjectContext.save()
        }
        catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    func fetch(entityName: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
            return result
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
}

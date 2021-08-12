//
//  PersistenceManager.swift
//  PersistenceManager
//
//  Created by William Finnis on 10/08/2021.
//

import Foundation
import CoreData

struct PersistenceManager {
    // Storage for Core Data
    let container: NSPersistentContainer

    // An initializer to load Core Data, optionally able to use an in-memory store.
    init() {
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

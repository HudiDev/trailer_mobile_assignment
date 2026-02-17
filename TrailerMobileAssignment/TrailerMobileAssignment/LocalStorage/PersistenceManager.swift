//
//  PersistenceManager.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/15/26.
//

import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        // TODO: - have name in config file
        container = NSPersistentContainer(name: "LocalMovie")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

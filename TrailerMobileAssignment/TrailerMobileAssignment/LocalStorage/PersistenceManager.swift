//
//  Untitled.swift
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
        container = NSPersistentContainer(name: "LocalMovie") // Must match your .xcdatamodeld filename
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

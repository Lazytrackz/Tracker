//
//  DataBaseStore.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 03.10.2026.
//

import Foundation
import CoreData

//MARK: - DataBaseStore

final class DataBaseStore {
    
    //MARK: - Properties
    
    static let shared = DataBaseStore()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}

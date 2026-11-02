//
//  TrackerStore.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 23.09.2026.
//

import CoreData
import UIKit

//MARK: - TrackerStore

final class TrackerStore {
    
    //MARK: - Singletone
    
    private let context = DataBaseStore.shared.persistentContainer.viewContext
    
    //MARK: - Private properties
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    
    //MARK: - Methods
    
    func updateData(_ tracker: Tracker, _ trackerCategoryName: String) throws {
        guard let trackerCategoryCoreData = findCategory(trackerCategoryName) else { return }
        let trackerCoreData = TrackerCoreData(context: context)
        let id = setTrackerId(with: context)
        trackerCoreData.id = Int32(id)
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.addToCategory(trackerCategoryCoreData)
        DataBaseStore.shared.saveContext()
    }
    
    func rewriteData(_ tracker: Tracker, _ trackerCategoryName: String, _ currentCategoryName: String) throws {
        let id = Int32(tracker.id)
        guard let oldTrackerCategoryCoreData = findCategory(currentCategoryName) else { return }
        guard let newTrackerCategoryCoreData = findCategory(trackerCategoryName) else { return }
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: CoreDataIdentifiers.trackerCoreData)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        let results = try? context.fetch(fetchRequest)
        
        if let trackerCoreData = results?.first {
            trackerCoreData.name = tracker.name
            trackerCoreData.color = tracker.color
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule as NSObject
            trackerCoreData.removeFromCategory(oldTrackerCategoryCoreData)
            trackerCoreData.addToCategory(newTrackerCategoryCoreData)
            DataBaseStore.shared.saveContext()
        }else{
            print("Tracker not found")
        }
    }
    
    func deleteTracker(_ trackerId: UInt) {
        let id = Int32(trackerId)
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: CoreDataIdentifiers.trackerCoreData)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        let results = try? context.fetch(fetchRequest)
        
        if let trackerCoreData = results?.first {
            context.delete(trackerCoreData)
            DataBaseStore.shared.saveContext()
        }else{
            print("Tracker not found")
        }
    }
    
    //MARK: - Private methods
    
    private func findCategory(_ trackerCategoryName: String) -> TrackerCategoryCoreData? {
        var trackerCategoryCoreData: TrackerCategoryCoreData?
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: CoreDataIdentifiers.trackerCategoryCoreData)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "%K== %@", #keyPath(TrackerCategoryCoreData.name), trackerCategoryName)
        fetchRequest.predicate = predicate
        let results = try? context.fetch(fetchRequest)
        guard let results else { return nil }
        
        if !results.isEmpty {
            guard let result = results.first else { return TrackerCategoryCoreData(context: context) }
            trackerCategoryCoreData = result
        }else {
            trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData?.name = trackerCategoryName
        }
        guard let trackerCategoryCoreData else { return nil }
        return trackerCategoryCoreData
    }
    
    private func setTrackerId(with context: NSManagedObjectContext) -> Int {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: CoreDataIdentifiers.trackerCoreData)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let results = try? context.fetch(fetchRequest)
        return results?.count ?? 0
    }
}

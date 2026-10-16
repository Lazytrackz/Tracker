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
    
    //MARK: - Private methods
    
    private func findCategory(_ trackerCategoryName: String) -> TrackerCategoryCoreData? {
        var trackerCategoryCoreData: TrackerCategoryCoreData?
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
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
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let results = try? context.fetch(fetchRequest)
        return results?.count ?? 0
    }
}

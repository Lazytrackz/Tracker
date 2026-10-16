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
    
    func updateData(_ tracker: Tracker, _ category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        let id = setTrackerId(with: context)
        trackerCoreData.id = Int32(id)
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.addToCategory(category)
        DataBaseStore.shared.saveContext()
    }
    
    //MARK: - Private methods
    
    private func setTrackerId(with context: NSManagedObjectContext) -> Int {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let results = try? context.fetch(fetchRequest)
        return results?.count ?? 0
    }
}

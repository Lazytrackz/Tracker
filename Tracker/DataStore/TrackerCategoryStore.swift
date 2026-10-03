//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 23.09.2026.
//

import CoreData
import UIKit

//MARK: - TrackerCategoryStore

final class TrackerCategoryStore: NSObject {
    
    //MARK: - Properties
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    //MARK: - Private properties
    
    private var trackerStore = TrackerStore()
    
    //MARK: - Singletone
    
    private let context = DataBaseStore.shared.persistentContainer.viewContext
    
    //MARK: - Lazy properties
    
    private lazy var fetchedResultsController:
    NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCategoryCoreData.name),
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    //MARK: - Methods
    
    func getCategoryArray(currentDate: String) -> [TrackerCategory] {
        var categoryArray = [TrackerCategory]()
        var trackerArray = [Tracker]()
        guard let objects = self.fetchedResultsController.fetchedObjects else { return [] }
        
        for (_, entity) in objects.enumerated() {
            let trackersSet = entity.value(forKey: "trackers") as? Set<TrackerCoreData> ?? []
            
            for tracker in trackersSet {
                let scheduleSet = tracker.value(forKey: "schedule") as? Array<WeekDays> ?? []
                for days in scheduleSet {
                    if days.rawValue == currentDate {
                        
                        guard let color = tracker.color as? UIColor,
                              let schedule = tracker.schedule as? [WeekDays],
                              let emoji = tracker.emoji else {return []}
    
                        let tracker = Tracker(id: UInt(tracker.id), name: tracker.name, color: color, emoji: emoji, schedule: schedule)
                        trackerArray.append(tracker)
                    }
                }
            }
            trackerArray.sort(by: {$0.id < $1.id})
            categoryArray.append(TrackerCategory(name: entity.name ?? "", trackers: trackerArray))
            categoryArray.sort(by: {$0.name < $1.name})
        }
        return categoryArray
    }
    
    func updateData(_ trackerCategoryName: String, _ tracker: Tracker) throws {
        guard let trackerCategoryCoreData = checkExistingCategory(trackerCategoryName) else { return }
        DataBaseStore.shared.saveContext()
        try trackerStore.updateData(tracker, trackerCategoryCoreData)
    }
    
    //MARK: - Private methods
    
    private func checkExistingCategory(_ trackerCategoryName: String) -> TrackerCategoryCoreData? {
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
}

//MARK: - Extension

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

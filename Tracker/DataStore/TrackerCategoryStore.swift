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
    
    func fetchCategoryList(completion: ([String]) -> Void) {
        var categories = [String]()
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        let results = try? context.fetch(fetchRequest)
        
        guard let results else { return }
        for (_, entity) in results.enumerated() {
            categories.append(entity.name ?? "")
        }
        completion(categories)
    }
    
    func getCategoryArray(currentDate: String) -> [TrackerCategory] {
        var categoryArray = [TrackerCategory]()
        
        guard let objects = self.fetchedResultsController.fetchedObjects else { return [] }
        
        for (_, entity) in objects.enumerated() {
            let trackersSet = entity.value(forKey: "trackers") as? Set<TrackerCoreData> ?? []
            var trackerArray = [Tracker]()
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
            
            if !trackerArray.isEmpty {
                categoryArray.append(TrackerCategory(name: entity.name ?? "", trackers: trackerArray))
                categoryArray.sort(by: {$0.name < $1.name})
            }
        }
        return categoryArray
    }
    
    func addCategory(_ name: String) {
        if checkExistingCategory(name) {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.name = name
            DataBaseStore.shared.saveContext()
        } else {
            print("error")
        }
    }
    
    //MARK: - Private methods
    
    private func checkExistingCategory(_ trackerCategoryName: String) -> Bool {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "%K== %@", #keyPath(TrackerCategoryCoreData.name), trackerCategoryName)
        fetchRequest.predicate = predicate
        let results = try? context.fetch(fetchRequest)
        guard let results else { return false }
        
        if !results.isEmpty {
            return false
        }else {
            return true
        }
    }
}

//MARK: - Extension

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    //MARK: - Methods
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

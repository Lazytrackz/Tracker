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
    
    private var trackerRecords = TrackerRecordStore()
    private var filterStore = FiltersStore()
    private var recordsArray = [TrackerRecord]()
    private var filter: String?
    private var currentData = Date()
    private lazy var weekDaysdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    private lazy var recordsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    //MARK: - Singletone
    
    private let context = DataBaseStore.shared.persistentContainer.viewContext
    
    //MARK: - Lazy properties
    
    private lazy var fetchedResultsController:
    NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: CoreDataIdentifiers.trackerCategoryCoreData)
        
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
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: CoreDataIdentifiers.trackerCategoryCoreData)
        fetchRequest.returnsObjectsAsFaults = false
        let results = try? context.fetch(fetchRequest)
        
        guard let results else { return }
        for (_, entity) in results.enumerated() {
            categories.append(entity.name ?? "")
        }
        completion(categories)
    }
    
    func getCategoryArray(_ currentDate: Date, completion: ([TrackerCategory]) -> Void) {
        self.currentData = currentDate
        let currentDateString = weekDaysdateFormatter.string(from: currentDate).capitalized
        var categoryArray = [TrackerCategory]()
        guard let objects = self.fetchedResultsController.fetchedObjects else { return }
        
        for (_, entity) in objects.enumerated() {
            let trackersSet = entity.value(forKey: "trackers") as? Set<TrackerCoreData> ?? []
            var trackerArray = [Tracker]()
            for tracker in trackersSet {
                let scheduleSet = tracker.value(forKey: "schedule") as? Array<WeekDays> ?? []
                for days in scheduleSet {
                    if days.rawValue == currentDateString  {
                        
                        guard let color = tracker.color as? UIColor,
                              let schedule = tracker.schedule as? [WeekDays],
                              let emoji = tracker.emoji else {return }
                        
                        let tracker = Tracker(id: UInt(tracker.id), name: tracker.name, color: color, emoji: emoji, schedule: schedule)
                        trackerArray.append(tracker)
                    }
                }
            }
            var filteredArray = filterTrackers(trackerArray, currentDate)
            if !filteredArray.isEmpty {
                filteredArray.sort(by: {$0.id < $1.id})
                categoryArray.append(TrackerCategory(name: entity.name ?? "", trackers: filteredArray))
                categoryArray.sort(by: {$0.name < $1.name})
            }
        }
        completion(categoryArray)
    }
    
    func checkCompletedTrackers(_ trackerId: UInt, completion: (CompletedTrackers) -> Void) {
        var checkButtonStatus = false
        var completedTrackersCount = 0
        
        if !recordsArray.isEmpty{
            for tracker in recordsArray {
                if tracker.trackerId == trackerId {
                    completedTrackersCount += 1
                    if getRecordsData(date: currentData) == getRecordsData(date: tracker.date) {
                        checkButtonStatus = true
                    }
                }
            }
        }
        let result = CompletedTrackers(completedTrackersCount: completedTrackersCount, completedForCurrentDate: checkButtonStatus)
        completion(result)
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
    
    private func getRecordsData(date: Date) -> String {
        recordsDateFormatter.string(from: date)
    }
    
    private func filterTrackers(_ trackerArray: [Tracker], _ currentDate: Date) -> [Tracker] {
        trackerRecords.getRecordsArray(completion: ({ [weak self] records in
            self?.recordsArray = records
        }))
        filterStore.loadFilter(completion: ({ [weak self] filter in
            self?.filter = filter
        }))
        
        var filteredTrackersArray = [Tracker]()
        
        switch filter {
        case FilterType.completedTrackers.rawValue:
            for tracker in trackerArray {
                if recordsArray.contains(where: {$0.trackerId == tracker.id &&  getRecordsData(date: $0.date) == getRecordsData(date: currentDate)}){
                    filteredTrackersArray.append(tracker)
                }
            }
            return filteredTrackersArray
            
        case FilterType.incompleteTrackers.rawValue:
            for tracker in trackerArray {
                if recordsArray.contains(where: {$0.trackerId == tracker.id &&  getRecordsData(date: $0.date) == getRecordsData(date: currentDate)}){
                    continue
                }
                filteredTrackersArray.append(tracker)
            }
            return filteredTrackersArray
            
        case FilterType.trackersForToday.rawValue:
            filteredTrackersArray = trackerArray
            filterStore.setFilter(FilterType.allTrackers.rawValue)
            
        case FilterType.allTrackers.rawValue:
            filteredTrackersArray = trackerArray
            
        default:
            filteredTrackersArray = trackerArray
        }
        return filteredTrackersArray
    }
    
    private func checkExistingCategory(_ trackerCategoryName: String) -> Bool {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: CoreDataIdentifiers.trackerCategoryCoreData)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), trackerCategoryName)
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

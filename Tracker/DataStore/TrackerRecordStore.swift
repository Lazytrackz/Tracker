//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 23.09.2026.
//

import Foundation
import CoreData
import UIKit

//MARK: - TrackerRecordsStore

final class TrackerRecordStore {
    
    //MARK: - Private properties
    
    private let context: NSManagedObjectContext
    
    //MARK: - Init
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Lazy properties
    
    private lazy var recordsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    //MARK: - Methods
    
    func getRecordsArray() -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackers = try? context.fetch(request)
        guard let trackers else { return [] }
        var trackerRecordsArray = [TrackerRecord]()
        
        for tracker in trackers {
            let id = tracker.id
            let recordsSet = tracker.value(forKey: "records") as? Set<TrackerRecordCoreData> ?? []
            
            for record in recordsSet {
                guard let date = record.date else { return [] }
                let newRecord = TrackerRecord(trackerId: UInt(id), date: date)
                trackerRecordsArray.append(newRecord)
            }
        }
        return trackerRecordsArray
    }
    
    func deleteData(_ trackerRecord: TrackerRecord) throws {
        guard let tracker = checkExistingTracker(trackerRecord.trackerId) else { return }
        let recordsSet = tracker.value(forKey: "records") as? Set<TrackerRecordCoreData> ?? []
        
        for record in recordsSet {
            guard let date = record.date else { return }
            if getRecordsData(date: date) == getRecordsData(date: trackerRecord.date) {
                context.delete(record)
                break
            }
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func addData(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        guard let tracker = checkExistingTracker(trackerRecord.trackerId) else { return }
        trackerRecordCoreData.date = trackerRecord.date
        trackerRecordCoreData.addToTracker(tracker)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    //MARK: - Private methods
    
    private func getRecordsData(date: Date) -> String {
        return recordsDateFormatter.string(from: date)
    }
    
    private func checkExistingTracker(_ trackerId: UInt) -> TrackerCoreData? {
        var trackerCoreData: TrackerCoreData?
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == %@", String(trackerId))
        fetchRequest.predicate = predicate
        let results = try! context.fetch(fetchRequest)
        
        if !results.isEmpty {
            trackerCoreData = results.first
        }
        return trackerCoreData
    }
}

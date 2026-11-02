//
//  ExistingTrackerStore.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 24.10.2026.
//

import Foundation
import UIKit

//MARK: - ExistingTrackerStore

class ExistingTrackerStore {
    
    //MARK: - Private properties
    
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Methods
    
    func saveCategory(_ categoryName: String) {
        userDefaults.set(categoryName, forKey: UserDefaultsIdentifiers.categoryNameKey)
    }
    
    func saveCompletedTrackerCount(_ count: Int) {
        userDefaults.set(count, forKey: UserDefaultsIdentifiers.completedTrackerCountKey)
    }
    
    func saveTracker(_ tracker: Tracker) {
        let id = tracker.id
        let name = tracker.name
        let color = tracker.color
        let emoji = tracker.emoji
        let schedule = tracker.schedule
        var dataColor: Data?
        do {
            dataColor = try NSKeyedArchiver.archivedData(
                withRootObject: color,
                requiringSecureCoding: true
            )
        } catch {
            print("Ошибка архивирования: \(error)")
        }
        userDefaults.set(id, forKey: UserDefaultsIdentifiers.trackerIdKey)
        userDefaults.set(name, forKey: UserDefaultsIdentifiers.trackerNameKey)
        userDefaults.set(dataColor, forKey: UserDefaultsIdentifiers.trackerColorKey)
        userDefaults.set(emoji, forKey: UserDefaultsIdentifiers.trackerEmojiKey)
        
        do {
            let data = try JSONEncoder().encode(schedule)
            userDefaults.set(data, forKey: UserDefaultsIdentifiers.trackerScheduleKey)
        } catch {
            print("Ошибка кодирования: \(error)")
        }
    }
    
    func loadTracker(completion: (Tracker) -> Void) {
        let id = userDefaults.integer(forKey: UserDefaultsIdentifiers.trackerIdKey)
        let name = userDefaults.string(forKey: UserDefaultsIdentifiers.trackerNameKey)
        let emoji = userDefaults.string(forKey: UserDefaultsIdentifiers.trackerEmojiKey)
        var color: UIColor?
        guard let colorData = userDefaults.data(forKey: UserDefaultsIdentifiers.trackerColorKey) else { return }
        do {
            color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch {
            print("Ошибка десериализации: \(error.localizedDescription)")
            
        }
        
        var schedule: [WeekDays]?
        do {
            let jsonData = userDefaults.value(forKey: UserDefaultsIdentifiers.trackerScheduleKey) as? Data
            if let data = jsonData {
                let decoder = JSONDecoder()
                schedule = try decoder.decode([WeekDays].self, from: data)
            }
        } catch {
            print("Ошибка десериализации: \(error)")
        }
        
        let result = Tracker(id: UInt(id), name: name ?? "", color: color ?? .colorSelection1, emoji: emoji ?? "", schedule: schedule ?? [])
        completion(result)
    }
    
    func loadCategoryName(completion: (String) -> Void) {
        guard let result = userDefaults.string(forKey: UserDefaultsIdentifiers.categoryNameKey) else { return }
        completion(result)
    }
    
    func loadCompletedTrackerCount(completion: (Int) -> Void) {
        let result = userDefaults.integer(forKey: UserDefaultsIdentifiers.completedTrackerCountKey)
        completion(result)
    }
    
    func deleteAll() {
        let bundleID = Bundle.main.bundleIdentifier
        guard let bundleID else { return }
        print("delete all")
        userDefaults.removePersistentDomain(forName: bundleID)
    }
}

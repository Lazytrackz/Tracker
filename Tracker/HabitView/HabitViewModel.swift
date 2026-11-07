//
//  HabitViewModel.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 23.10.2026.
//

import Foundation

//MARK: - HabitViewModel

final class HabitViewModel {
    
    //MARK: - Properties
    
    var categoryUpdated: Binding<Any>?
    var trackerUpdated: Binding<Any>?
    var completedTrackerCountUpdated: Binding<Any>?
    
    //MARK: - Private properties
    
    private var tracker: Tracker?
    private var categoryName: String?
    private var completedTrackerCount: Int?
    private var existingTrackerStore: ExistingTrackerStore?
    private var trackerStore: TrackerStore?
    private var categoryViewStore: CategoryViewStore?
    
    //MARK: - Init
    
    convenience init() {
        self.init(trackerStore: TrackerStore(), existingTrackerStore: ExistingTrackerStore(), categoryViewStore: CategoryViewStore())
    }
    
    init(trackerStore: TrackerStore, existingTrackerStore: ExistingTrackerStore, categoryViewStore: CategoryViewStore) {
        self.trackerStore = trackerStore
        self.existingTrackerStore = existingTrackerStore
        self.categoryViewStore = categoryViewStore
    }
    
    //MARK: - Methods
    
    func updateHabitView() {
        existingTrackerStore?.loadCategoryName(completion: { [weak self] category in
            self?.categoryName = category
            self?.categoryUpdated?()
        })
        existingTrackerStore?.loadTracker(completion: { [weak self] tracker in
            self?.tracker = tracker
            self?.trackerUpdated?()
        })
        
        existingTrackerStore?.loadCompletedTrackerCount(completion: { [weak self] count in
            self?.completedTrackerCount = count
            self?.completedTrackerCountUpdated?()
        })
    }
    
    func getCategoryName() -> String? {
        guard let categoryName else { return nil}
        return categoryName
    }
    
    func getTracker() -> Tracker? {
        guard let tracker else { return nil}
        return tracker
    }
    
    func getCompletedTrackerCount() -> Int? {
        return completedTrackerCount
    }
    
    func createTracker(_ tracker: Tracker, _ categoryName: String) {
        do {
            try trackerStore?.updateData(tracker, categoryName)
        } catch {
            print(error)
        }
        
    }
    
    func rewriteExistingTracker(_ tracker: Tracker, _ categoryName: String) {
        guard let currentCategory = self.categoryName else { return }
        do {
            try trackerStore?.rewriteData(tracker, categoryName, currentCategory)
        } catch {
            print(error)
        }
    }
    
    func saveCategoryForView(_ categoryName: String) {
        categoryViewStore?.setCategoryName(categoryName)
    }
}

//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 23.10.2026.
//

import Foundation

//MARK: - TrackersViewModel

final class TrackersViewModel {
    
    //MARK: - Properties
    
    var onTasksUpdated: Binding<Any>?
    
    
    //MARK: - Private properties
    
    private var categories = [TrackerCategory]()
    private var filteredCategories = [TrackerCategory]()
    private var categoriesModel: TrackerCategoryStore?
    private var trackerStore: TrackerStore?
    private var existingTrackerStore: ExistingTrackerStore?
    private var trackerRecordStore = TrackerRecordStore()
    private var currentDate = Date()
    
    private lazy var recordsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private lazy var weekDaysdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    //MARK: - Init
    
    convenience init() {
        self.init(categoriesModel: TrackerCategoryStore(), existingTrackerStore: ExistingTrackerStore(), trackerStore: TrackerStore())
    }
    
    init(categoriesModel: TrackerCategoryStore, existingTrackerStore: ExistingTrackerStore, trackerStore: TrackerStore) {
        self.categoriesModel = categoriesModel
        self.existingTrackerStore = existingTrackerStore
        self.trackerStore = trackerStore
        self.categoriesModel?.delegate = self
    }
    
    //MARK: - Methods
    
    func setData(_ currentDate: Date) {
        self.currentDate = currentDate
    }
    
    func getTrackerCategoryStore() -> TrackerCategoryStore? {
        categoriesModel
    }
    
    func updateCollection() {
        categoriesModel?.getCategoryArray(currentDate, completion: { [weak self] categories in
            self?.categories = categories
            self?.filteredCategories = categories
            self?.onTasksUpdated?()
        })
    }
    
    func filterData(by searchedText: String) -> Bool {
        if !searchedText.isEmpty {
            filteredCategories = categories.filter  {$0.trackers.contains(where: {$0.name?.lowercased() == searchedText.lowercased()})}
            return true
            
        }else {
            updateCollection()
        }
        return false
    }
    
    func deleteTracker(_ trackerId: UInt) {
        trackerStore?.deleteTracker(trackerId)
    }
    
    func deleteTrackerRecord(_ trackerId: UInt) {
        trackerRecordStore.deleteTrackerRecord(trackerId)
    }
    
    func addRecord(_ record: TrackerRecord) {
        do{
            try trackerRecordStore.addData(record)
        }catch {
            print(error)
        }
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        do{
            try trackerRecordStore.deleteData(record)
        }catch {
            print(error)
        }
    }
    
    func checkCompletedTrackers(_ trackerId: UInt) -> CompletedTrackers {
        var checkButtonStatus = false
        var completedTrackersCount = 0
        categoriesModel?.checkCompletedTrackers(trackerId, completion: ({ records in
            checkButtonStatus = records.completedForCurrentDate
            completedTrackersCount = records.completedTrackersCount
        }))
        
        return CompletedTrackers(completedTrackersCount: completedTrackersCount, completedForCurrentDate: checkButtonStatus)
    }
    
    func findTrackers() -> Bool {
        guard !filteredCategories.isEmpty else { return false }
        return true
    }
    
    func getCategoriesCount() -> Int {
        filteredCategories.count
    }
    
    func getTrackersCount(at section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func getCategory(at sectionIndex: Int) -> String {
        filteredCategories[sectionIndex].name
    }
    
    func getTracker(at sectionIndex: Int, at rowIndex: Int) -> Tracker {
        let name = filteredCategories[sectionIndex].trackers[rowIndex].name
        let id = filteredCategories[sectionIndex].trackers[rowIndex].id
        let schedule = filteredCategories[sectionIndex].trackers[rowIndex].schedule
        let emoji = filteredCategories[sectionIndex].trackers[rowIndex].emoji
        let color = filteredCategories[sectionIndex].trackers[rowIndex].color
        let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
        
        return tracker
    }
    
    func saveExistingTracker(_ tracker: Tracker) {
        existingTrackerStore?.saveTracker(tracker)
    }
    
    func saveCategoryName(_ name: String) {
        existingTrackerStore?.saveCategory(name)
    }
    
    func saveCompletedTrackerCount(_ count: Int) {
        existingTrackerStore?.saveCompletedTrackerCount(count)
    }
    
    //MARK: - Private methods
    
    private func getRecordsData(date: Date) -> String {
        recordsDateFormatter.string(from: date)
    }
}

//MARK: - Extension

extension TrackersViewModel: TrackerCategoryStoreDelegate {
    
    //MARK: - Methods
    
    func didUpdate() {
        updateCollection()
    }
}

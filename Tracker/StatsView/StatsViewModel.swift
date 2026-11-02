//
//  StatsViewModel.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 21.10.2026.
//

import Foundation

final class StatsViewModel {
    
    
    //MARK: - Properties
    
    var onTasksUpdated: Binding<Any>?
    
    //MARK: - Private properties
    
    private var categories = [String]()
    private var category: String?
    private var trackerRecordsModel: TrackerRecordStore?
    private var bestPeriodCount = 0
    private var idealDaysCount = 0
    private var completedTrackersCount = 0
    private var averageCompletedTrackersCount = 0
    
    //MARK: - Init
    
    convenience init() {
        self.init(trackerRecordsModel: TrackerRecordStore())
    }
    
    init(trackerRecordsModel: TrackerRecordStore) {
        self.trackerRecordsModel = trackerRecordsModel
        
    }
    
    //MARK: - Methods
    
    func updateCounts() {
        trackerRecordsModel?.fetchCategoryList(){ [weak self] trackerRecords in
            self?.bestPeriodCount = trackerRecords.bestPeriodCount
            self?.idealDaysCount = trackerRecords.idealDaysCount
            self?.completedTrackersCount = trackerRecords.completedTrackersCount
            self?.averageCompletedTrackersCount = trackerRecords.averageCompletedTrackersCount
            self?.onTasksUpdated?()
        }
    }
    
    func getbestPeriodCount() -> Int {
        bestPeriodCount
    }
    
    func getIdealDaysCount() -> Int {
        idealDaysCount
    }
    
    func getCompletedTrackersCount() -> Int {
        completedTrackersCount
    }
    
    func getAverageCompletedTrackersCount() -> Int {
        averageCompletedTrackersCount
    }
}

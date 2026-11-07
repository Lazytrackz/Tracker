//
//  FilterViewModel.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 27.10.2026.
//

import Foundation

//MARK: - FilterType

enum FilterType: String, Codable {
    case allTrackers = "Все трекеры"
    case trackersForToday = "Трекеры на сегодня"
    case completedTrackers = "Завершенные"
    case incompleteTrackers = "Не завершенные"
}

//MARK: - FilterViewModel

final class FilterViewModel {
    
    //MARK: - Properties
    
    var onTasksUpdated: Binding<Any>?
    
    //MARK: - Private properties
    
    private var filters = [FilterType.allTrackers, .trackersForToday, .completedTrackers, .incompleteTrackers]
    private var filtersStore: FiltersStore?
    private var filter: String?
    
    //MARK: - Init
    
    convenience init() {
        self.init(filtersStore: FiltersStore())
    }
    
    init(filtersStore: FiltersStore) {
        self.filtersStore = filtersStore
    }
    
    //MARK: - Methods
    
    func updateFilterTableView() {
        filtersStore?.loadFilter(){ [weak self] filter in
            self?.filter = filter
            self?.onTasksUpdated?()
        }
    }
    
    func setFilter(_ name: String) {
        filtersStore?.setFilter(name)
    }
    
    func checkSelectedCell() -> Int? {
        var cellIndex: Int?
        for (index, currentFilter) in filters.enumerated() {
            if currentFilter.rawValue == filter {
                cellIndex = index
            }
        }
        guard let cellIndex else { return nil }
        return cellIndex
    }
    
    func getCurrentFilter() -> String? {
        guard let filter else { return nil }
        return filter
    }
    
    func getFilterCount() -> Int {
        filters.count
    }
    
    func getFilterName(at index: Int) -> String {
        filters[index].rawValue
    }
}

//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 11.10.2026.
//

import Foundation

typealias Binding<T> = () -> Void

//MARK: - CategoryViewModel

final class CategoryViewModel {
    
    //MARK: - Properties
    
    var onTasksUpdated: Binding<Any>?
    
    //MARK: - Private properties
    
    private var categories = [String]()
    private var category: String?
    private var categoriesModel: TrackerCategoryStore?
    
    //MARK: - Init
    
    convenience init() {
        self.init(categoriesModel: TrackerCategoryStore())
    }
    
    init(categoriesModel: TrackerCategoryStore) {
        self.categoriesModel = categoriesModel
    }
    
    //MARK: - Methods
    
    func updateCategoriesTableView() {
        categoriesModel?.fetchCategoryList(){ [weak self] categories in
            self?.categories = categories
            self?.onTasksUpdated?()
        }
    }
    
    func getCategoriesCount() -> Int {
        categories.count
    }
    
    func getCategoriesName(at index: Int) -> String {
        categories[index]
    }
}

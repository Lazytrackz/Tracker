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
    private var existingTrackerStore: ExistingTrackerStore?
    private var categoryViewStore: CategoryViewStore?
    private var categoryName: String?
    
    //MARK: - Init
    
    convenience init() {
        self.init(categoriesModel: TrackerCategoryStore(), existingTrackerStore: ExistingTrackerStore(), categoryViewStore: CategoryViewStore())
    }
    
    init(categoriesModel: TrackerCategoryStore, existingTrackerStore: ExistingTrackerStore, categoryViewStore: CategoryViewStore) {
        self.categoriesModel = categoriesModel
        self.existingTrackerStore = existingTrackerStore
        self.categoryViewStore = categoryViewStore
    }
    
    //MARK: - Methods
    
    func updateCategoriesTableView() {
        categoriesModel?.fetchCategoryList(){ [weak self] categories in
            self?.categories = categories
            self?.onTasksUpdated?()
        }
        categoryViewStore?.loadCategoryName(completion: { [weak self] categoryName in
            self?.categoryName = categoryName
        })
    }
    
    func getCategoriesCount() -> Int {
        categories.count
    }
    
    func getCategoriesName(at index: Int) -> String {
        categories[index]
    }
    
    func deleteCategory (_ categoryName: String) {
        categoriesModel?.deleteCategory(categoryName)
    }
    
    func saveCategoryName(_ name: String) {
        existingTrackerStore?.saveCategory(name)
    }
    
    func getCategoryNameForView() -> String? {
        categoryName
    }
    
}

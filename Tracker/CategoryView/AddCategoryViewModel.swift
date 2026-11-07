//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 06.11.2026.
//

import Foundation

//MARK: - AddCategoryViewModel

final class AddCategoryViewModel {

    //MARK: - Private properties
    
    private var categoriesModel: TrackerCategoryStore?
    private var existingTrackerStore: ExistingTrackerStore?
    private var categoryName: String?
    
    //MARK: - Init
    
    convenience init() {
        self.init(categoriesModel: TrackerCategoryStore(), existingTrackerStore: ExistingTrackerStore())
    }
    
    init(categoriesModel: TrackerCategoryStore, existingTrackerStore: ExistingTrackerStore) {
        self.categoriesModel = categoriesModel
        self.existingTrackerStore = existingTrackerStore
    }
    
    //MARK: - Methods
    
    func deleteCategory(_ categoryName: String) {
        categoriesModel?.deleteCategory(categoryName)
    }
    
    func addCategory(_ categoryName: String) {
        categoriesModel?.addCategory(categoryName)
    }
    
    func getCategoryName() -> String {
        existingTrackerStore?.loadCategoryName(completion: { [weak self] category in
            self?.categoryName = category
        })
        return categoryName ?? ""
    }
    
    func rewriteExistingCategory(_ categoryName: String) {
        guard let currentCategory = self.categoryName else { return }
        
        do {
            try categoriesModel?.rewriteData(categoryName, currentCategory)
        } catch {
            print(error)
        }
    }
}

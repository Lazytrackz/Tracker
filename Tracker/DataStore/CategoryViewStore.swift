//
//  CategoryViewStore.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 07.11.2026.
//

import Foundation


//MARK: - CategoryViewStore

final class CategoryViewStore {
    
    //MARK: - Private properties
    
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Methods
    
    func setCategoryName (_ categoryName: String) {
        userDefaults.set(categoryName, forKey: UserDefaultsIdentifiers.categoryNameForViewKey)
    }
    
    func loadCategoryName(completion: (String) -> Void){
        guard let result = userDefaults.string(forKey: UserDefaultsIdentifiers.categoryNameForViewKey) else { return }
        print(result)
        completion(result)
    }
}

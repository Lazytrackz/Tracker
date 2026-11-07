//
//  FiltersStore.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 28.10.2026.
//

import Foundation

//MARK: - FiltersStore

final class FiltersStore {
    
    //MARK: - Private properties
    
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Methods
    
    func setFilter (_ filterName: String) {
        userDefaults.set(filterName, forKey: UserDefaultsIdentifiers.filterNameKey)
    }
    
    func loadFilter(completion: (String) -> Void){
        guard let result = userDefaults.string(forKey: UserDefaultsIdentifiers.filterNameKey) else { return }
        completion(result)
    }
}

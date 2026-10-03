//
//  TrackerCategoryStoreDelegate.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 27.09.2026.
//

import Foundation

//MARK: - TrackerCategoryStoreDelegate

protocol TrackerCategoryStoreDelegate: AnyObject {
    
    //MARK: - Methods
    
    func didUpdate()
}

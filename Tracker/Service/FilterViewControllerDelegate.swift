//
//  FilterViewControllerDelegate.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 28.10.2026.
//

import Foundation

//MARK: - FilterViewControllerDelegate

protocol FilterViewControllerDelegate: AnyObject {
    
    //MARK: - Methods
    
    func updateFilter(_ filterType: String)
}

//
//  HabbitViewControllerDelegate.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 16.10.2026.
//

import Foundation

//MARK: - CategoryViewControllerDelegate

protocol CategoryViewControllerDelegate: AnyObject {
    
    //MARK: - Methods
    
    func setCategory(_ categoryName: String)
}

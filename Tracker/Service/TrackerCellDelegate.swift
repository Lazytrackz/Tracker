//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 08.09.2026.
//

import Foundation

//MARK: - TrackerCellDelegate

protocol TrackerCellDelegate: AnyObject {
    
    //MARK: - Public methods
    
    func trackerCellCheckButtonDidTap(_ cell: TrackerCell, buttonStatus: Bool)
}

//
//  ScheduleViewDelegate.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 12.09.2026.
//

import Foundation

//MARK: - TrackerCellDelegate

protocol ScheduleViewDelegate: AnyObject {
    
    //MARK: - Public methods
    
    func scheduleViewDoneButtonDidTap(scheduleArray: [WeekDays])
}

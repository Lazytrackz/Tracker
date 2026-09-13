//
//  Tracker.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 01.09.2026.
//

import Foundation
import UIKit

//MARK: - TrackerModel

enum WeekDays: String {
    case sunday = "Воскресенье"
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
}

struct Tracker {
    let id: UInt
    let name: String?
    let color: UIColor
    let emoji: String
    let schedule: [WeekDays]
}

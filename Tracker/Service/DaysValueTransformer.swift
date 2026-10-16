//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 26.09.2026.
//

import Foundation

//MARK: - DaysValueTransformer

@objc
final class DaysValueTransformer: ValueTransformer {
    
    //MARK: - Methods
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDays] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([WeekDays].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}

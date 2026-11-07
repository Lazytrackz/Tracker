//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 01.11.2026.
//
import Foundation
import AppMetricaCore

//MARK: - AnalyticsConstants

enum AnalyticsScreen: String {
    case main = "Main"
}

enum AnalyticsItem: String {
    case addTrack = "add_track"
    case track, filter, edit, delete
}

enum AnalyticsEvent: String {
    case open, close, click
}


//MARK: - AnalyticsService

final class AnalyticsService {
    
    
    //MARK: - Properties
    
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: APIKeys.yandexMetricaKey) else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func report(_ event: AnalyticsEvent, screen: AnalyticsScreen? = nil, item: AnalyticsItem? = nil) {
        let screen = screen?.rawValue ?? ""
        let item = item?.rawValue ?? ""
        let parameters: [AnyHashable: Any] = ["screen" : screen, "item" : item]
        AppMetrica.reportEvent(name: event.rawValue, parameters: parameters, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        print(event)
    }
}

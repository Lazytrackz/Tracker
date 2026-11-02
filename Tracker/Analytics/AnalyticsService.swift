//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 01.11.2026.
//
import Foundation
import AppMetricaCore

//MARK: - AnalyticsService

final class AnalyticsService {
    
    //MARK: - Properties
    
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: APIKeys.yandexMetricaKey) else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func reportEvent(event: String, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        print(event)
    }
}

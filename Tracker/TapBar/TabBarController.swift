//
//  TabBarController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 29.08.2026.
//

import Foundation
import UIKit

// MARK: - TabBarController

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        configureViewControllers()
    }
    
    // MARK: - Private methods
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
    }
    
    private func configureViewControllers() {
        let trackerViewController = TrackersViewController()
        let statsViewController = StatsViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        statsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        self.viewControllers = [navigationController, statsViewController]
    }
}

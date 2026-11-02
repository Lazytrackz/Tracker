//
//  TabBarController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 29.08.2026.
//


import UIKit

// MARK: - TabBarController

final class TabBarController: UITabBarController {
 
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        configureViewControllers()
        self.delegate = self
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
        tabBar.backgroundColor = .ypWhiteIOS
    }
    
    private func configureViewControllers() {
        let trackerViewController = TrackersViewController()
        let statsViewController = StatsViewController()
        let trackerViewTitleText = NSLocalizedString("tabbar_trackers", comment: "Text for trackerViewController.tabBarItem")
        let statsViewTitleText = NSLocalizedString("tabbar_statistics", comment: "Text for statsViewController.tabBarItem")
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: trackerViewTitleText,
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        statsViewController.tabBarItem = UITabBarItem(
            title: statsViewTitleText,
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        self.viewControllers = [navigationController, statsViewController]
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
        if let selectedViewController = tabBarController.selectedViewController as? StatsViewController {
            selectedViewController.updateData()
        }
    }
}

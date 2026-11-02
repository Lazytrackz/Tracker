//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 08.10.2026.
//

import UIKit

//MARK: - OnboardingViewController

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: - Lazy properties
    
    lazy var pages: [UIViewController] = {
        let first = OnboardingPage()
        first.image = UIImage(resource: .onboardingPageImageFirst)
        first.text = OnboardingText.firstPage
        let second = OnboardingPage()
        second.image = UIImage(resource: .onboardingPageImageSecond)
        second.text = OnboardingText.secondPage
        return [first, second]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlackIOS
        pageControl.pageIndicatorTintColor = .ypBlack30IOS
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    //MARK: - Init
    
    override init(transitionStyle: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        configurePageControl()
    }
    
    //MARK: - Private methods
    
    private func configurePageControl() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 638),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -168),
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 178),
        ])
    }
    
    //MARK: - PageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        var previousIndex = viewControllerIndex - 1
        
        if previousIndex == -1 {
            previousIndex = pages.count-1
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        var nextIndex = viewControllerIndex + 1
        if nextIndex == pages.count {
            nextIndex = 0
        }
        return pages[nextIndex]
    }
    
    //MARK: - PageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

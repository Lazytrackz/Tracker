//
//  OnboardingPage.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 08.10.2026.
//

import UIKit

//MARK: - OnboardingPage

final class OnboardingPage: UIViewController {
    
    
    
    //MARK: - Properties
    
    var text: String {
        get {
            return titleText ?? ""
        }
        set {
            let text = newValue
            titleText = text
        }
    }
    
    var image: UIImage {
        get {
            return pageImage ?? UIImage()
        }
        set {
            let image = newValue
            pageImage = image
        }
    }
    
    //MARK: - Private properties
    
    private var titleLabel: UILabel = UILabel()
    private var pageButton: UIButton = UIButton()
    private var pageImageView: UIImageView = UIImageView()
    private var test = TabBarController()
    private var titleText: String?
    private var pageImage: UIImage?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //MARK: - Actions
    
    @objc func didTapPageButton() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            guard let window else { return }
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = TabBarController()
            },
                              completion: nil)
        }
    }
    
    //MARK: - Methods
    
    func configureImageView() {
        pageImageView.image = pageImage
        pageImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageImageView)
        
        NSLayoutConstraint.activate([
            pageImageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Private methods
    
    private func configureView() {
        configureImageView()
        configurePageButton()
        configureTitleLabel()
    }
    
    private func configurePageButton() {
        pageButton = UIButton(type: .roundedRect)
        pageButton.backgroundColor = .ypBlackIOS
        pageButton.setTitle("Вот это технологии!", for: .normal)
        pageButton.setTitleColor(.ypWhiteIOS, for: .normal)
        pageButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        pageButton.titleLabel?.textColor = UIColor(resource: .ypBlackIOS)
        pageButton.addTarget(self, action: #selector(didTapPageButton), for: .touchUpInside)
        pageButton.layer.cornerRadius = 16
        pageButton.layer.masksToBounds = true
        pageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageButton)
        
        NSLayoutConstraint.activate([
            pageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            pageButton.heightAnchor.constraint(equalToConstant: 60),
            pageButton.widthAnchor.constraint(equalToConstant: 335)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.text = titleText
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 388),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}

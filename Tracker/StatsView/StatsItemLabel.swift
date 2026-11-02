//
//  StatsItemLabel.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 20.10.2026.
//

import UIKit

//MARK: - StatsItemLabel

final class StatsItemLabel: UILabel {
    
    //MARK: - Private properties
    
    private var itemNameLabel = UILabel()
    private var itemCountLabel = UILabel()
    
    //MARK: - Methods
    
    func configureItemLabel(_ name: String, _ count: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 343),
            self.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        let image = UIImage(resource: .statsItem)
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        configureCountLabel(count)
        configureNameLabel(name)
    }
    
    //MARK: - Private methods
    
    private func configureNameLabel(_ name: String) {
        itemNameLabel.backgroundColor = .ypWhiteIOS
        itemNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        itemNameLabel.textColor = UIColor(resource: .ypBlackIOS)
        itemNameLabel.text = name
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(itemNameLabel)
        
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 7),
            itemNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            itemNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            itemNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
        ])
    }
    
    private func configureCountLabel(_ count: String) {
        itemCountLabel.backgroundColor = .ypWhiteIOS
        itemCountLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        itemCountLabel.textColor = UIColor(resource: .ypBlackIOS)
        itemCountLabel.text = count
        itemCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(itemCountLabel)
        
        NSLayoutConstraint.activate([
            itemCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            itemCountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            itemCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
        ])
    }
}

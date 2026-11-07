//
//  CategoryCell.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 11.10.2026.
//

import UIKit

//MARK: - CategoryCell

final class CategoryCell: UITableViewCell {
    
    //MARK: - Private properties
    
    private var categoryViewMode = CategoryViewModel()
    private var categoryNameLabel = UILabel()
    private var categoryNameTextField = UILabel()
    private var choiceImage = UIImageView()
    private var isSelectedCell = false
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        contentView.frame = contentView.frame.inset(by: inset)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Methods
    
    func setCategoryText(_ categoryName: String) {
        categoryNameTextField.text = categoryName
    }
    
    func selectCell(_ isSelected: Bool) {
        isSelectedCell = isSelected
        checkSelectedCell()
    }
    
    //MARK: - Private methods
    
    private func configureCell() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .ypLightGrayIOS
        selectedBackgroundView?.layer.masksToBounds = false
        selectedBackgroundView?.layer.cornerRadius = 16
        configureNameLabel()
    }
    
    private func configureNameLabel() {
        categoryNameLabel.layer.cornerRadius = 16
        categoryNameLabel.layer.masksToBounds = true
        categoryNameLabel.backgroundColor = .ypBackgroundIOS
        categoryNameLabel.isUserInteractionEnabled = true
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryNameLabel)
        
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        configureTextField()
        configureChoiceImage()
    }
    
    private func configureTextField() {
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.addSubview(categoryNameTextField)
        
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: categoryNameLabel.topAnchor, constant: 27),
            categoryNameTextField.bottomAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: -26),
            categoryNameTextField.leadingAnchor.constraint(equalTo: categoryNameLabel.leadingAnchor, constant: 16),
        ])
    }
    
    private func configureChoiceImage() {
        choiceImage.image = .checkIcon
        checkSelectedCell()
        choiceImage.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.addSubview(choiceImage)
        
        NSLayoutConstraint.activate([
            choiceImage.topAnchor.constraint(equalTo: categoryNameLabel.topAnchor, constant: 25),
            choiceImage.bottomAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: -26),
            choiceImage.trailingAnchor.constraint(equalTo: categoryNameLabel.trailingAnchor, constant: -16)
        ])
    }
    
    private func checkSelectedCell() {
        choiceImage.isHidden = isSelectedCell
        choiceImage.isHidden = !isSelectedCell
    }
}

//
//  CategoryCell.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 11.10.2026.
//

import UIKit

//MARK: - CategoryCell

final class CategoryCell: UITableViewCell {
    
    //MARK: - Delegate
    
    weak var delegate: CategoryCellDelegate?
    
    //MARK: - Private properties
    
    private var categoryViewMode = CategoryViewModel()
    private var categoryNameLabel = UILabel()
    private var categoryNameTextField = UILabel()
    private var choiceButton = UIButton()
    private var isSelectedCell = false
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func didTapChoiceButton() {
        delegate?.didCloseCategoryView()
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
        configureChoiceButton()
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
    
    private func configureChoiceButton() {
        let image = UIImage(resource: .checkIcon)
        choiceButton.setImage(image, for: .normal)
        checkSelectedCell()
        choiceButton.translatesAutoresizingMaskIntoConstraints = false
        choiceButton.addTarget(self, action: #selector(didTapChoiceButton), for: .touchUpInside)
        categoryNameLabel.addSubview(choiceButton)
        
        NSLayoutConstraint.activate([
            choiceButton.topAnchor.constraint(equalTo: categoryNameLabel.topAnchor, constant: 25),
            choiceButton.bottomAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: -26),
            choiceButton.trailingAnchor.constraint(equalTo: categoryNameLabel.trailingAnchor, constant: -16)
        ])
    }
    
    private func checkSelectedCell() {
        if isSelectedCell {
            choiceButton.isEnabled = true
            choiceButton.isHidden = false
        } else {
            choiceButton.isEnabled = false
            choiceButton.isHidden = true
        }
    }
}

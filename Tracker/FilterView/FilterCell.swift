//
//  FilterCell.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 28.10.2026.
//

import UIKit

//MARK: - FilterCell

final class FilterCell: UITableViewCell {
    
    //MARK: - Delegate
    
    weak var delegate: FilterCellDelegate?
    
    //MARK: - Private properties
    
    private var filterViewMode = FilterViewModel()
    private var filterNameLabel = UILabel()
    private var filterTextField = UILabel()
    private var choiceButton = UIButton()
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
    
    //MARK: - Actions
    
    @objc private func didTapChoiceButton() {
        delegate?.didCloseFilterView()
    }
    
    //MARK: - Methods
    
    func setFilterText(_ filterName: String) {
        filterTextField.text = filterName
    }
    
    func selectCell(_ isSelected: Bool) {
        isSelectedCell = isSelected
        checkSelectedCell()
    }
    
    func getFilterName() -> String? {
        guard let name = filterTextField.text else { return nil }
        return name
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
        filterNameLabel.layer.cornerRadius = 16
        filterNameLabel.layer.masksToBounds = true
        filterNameLabel.backgroundColor = .ypBackgroundIOS
        filterNameLabel.isUserInteractionEnabled = true
        filterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filterNameLabel)
        
        NSLayoutConstraint.activate([
            filterNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            filterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filterNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        configureTextField()
        configureChoiceButton()
    }
    
    private func configureTextField() {
        filterTextField.translatesAutoresizingMaskIntoConstraints = false
        filterNameLabel.addSubview(filterTextField)
        
        NSLayoutConstraint.activate([
            filterTextField.topAnchor.constraint(equalTo: filterNameLabel.topAnchor, constant: 27),
            filterTextField.bottomAnchor.constraint(equalTo: filterNameLabel.bottomAnchor, constant: -26),
            filterTextField.leadingAnchor.constraint(equalTo: filterNameLabel.leadingAnchor, constant: 16),
        ])
    }
    
    private func configureChoiceButton() {
        let image = UIImage(resource: .checkIcon)
        choiceButton.setImage(image, for: .normal)
        checkSelectedCell()
        choiceButton.translatesAutoresizingMaskIntoConstraints = false
        choiceButton.addTarget(self, action: #selector(didTapChoiceButton), for: .touchUpInside)
        filterNameLabel.addSubview(choiceButton)
        
        NSLayoutConstraint.activate([
            choiceButton.topAnchor.constraint(equalTo: filterNameLabel.topAnchor, constant: 25),
            choiceButton.bottomAnchor.constraint(equalTo: filterNameLabel.bottomAnchor, constant: -26),
            choiceButton.trailingAnchor.constraint(equalTo: filterNameLabel.trailingAnchor, constant: -16)
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

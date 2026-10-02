//
//  ColorCollectionCell.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 16.09.2026.
//

import Foundation
import UIKit

//MARK: - ColorCollectionCell

final class ColorCollectionCell: UICollectionViewCell {
    
    //MARK: - Private properties
    
    private var borderLabel = UILabel()
    private var colorLabel = UILabel()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func setBorderLabelColorStatus(_ isSelected: Bool) {
        borderLabel.layer.borderColor =  isSelected ? colorLabel.backgroundColor?.cgColor : UIColor.ypWhiteIOS.cgColor
    }
    
    func setNewCell(color: UIColor) {
        borderLabel.layer.borderColor = UIColor.ypWhiteIOS.cgColor
        borderLabel.layer.borderWidth = 3
        colorLabel.backgroundColor = color
    }
    
    
    //MARK: - Private methods
    
    private func configureCell() {
        configureBorderLabel()
        configureColorLabel()
    }
    
    private func configureBorderLabel() {
        borderLabel.translatesAutoresizingMaskIntoConstraints = false
        borderLabel.layer.cornerRadius = 8
        borderLabel.layer.masksToBounds = true
        borderLabel.layer.borderWidth = 3
        borderLabel.layer.borderColor = UIColor.ypWhiteIOS.cgColor
        borderLabel.backgroundColor = .ypWhiteIOS
        contentView.addSubview(borderLabel)
        
        NSLayoutConstraint.activate([
            borderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            borderLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            borderLabel.heightAnchor.constraint(equalToConstant: 49),
            borderLabel.widthAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    private func configureColorLabel() {
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.layer.cornerRadius = 8
        colorLabel.layer.masksToBounds = true
        borderLabel.addSubview(colorLabel)
        
        NSLayoutConstraint.activate([
            colorLabel.centerXAnchor.constraint(equalTo: borderLabel.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: borderLabel.centerYAnchor),
            colorLabel.heightAnchor.constraint(equalToConstant: 40),
            colorLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

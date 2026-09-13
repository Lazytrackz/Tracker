//
//  CategoryCellHeader.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 06.09.2026.
//

import Foundation
import UIKit

//MARK: - CategoryCellHeader

final class CategoryCellHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    let titleLabel = UILabel()
    
    //MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

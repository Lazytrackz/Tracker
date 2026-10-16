//
//  EmojiCollectionCell.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 15.09.2026.
//

import UIKit

//MARK: - EmojiCollectionCell

final class EmojiCollectionCell: UICollectionViewCell {
    
    //MARK: - Private properties
    
    private var emojiLabel = UILabel()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Methods
    
    func setEmojiLabelColorStatus(_ isSelected: Bool) {
        emojiLabel.backgroundColor = isSelected ? .ypLightGrayIOS : .ypWhiteIOS
    }
    
    func setNewCell(emoji: String) {
        emojiLabel.text = emoji
        emojiLabel.backgroundColor = .ypWhiteIOS
    }
    
    //MARK: - Private methods
    
    private func configureCell() {
        configureEmojiLabel()
    }
    
    private func configureEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        emojiLabel.layer.cornerRadius = 16
        emojiLabel.layer.masksToBounds = true
        emojiLabel.backgroundColor = .ypWhiteIOS
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 46),
            emojiLabel.widthAnchor.constraint(equalToConstant: 46)
        ])
    }
}

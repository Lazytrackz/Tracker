//
//  TrackerCell.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 06.09.2026.
//

import UIKit

//MARK: - TrackerCell

final class TrackerCell: UICollectionViewCell {
    
    //MARK: - Delegate
    
    weak var delegate: TrackerCellDelegate?
    
    //MARK: - Private properties
    
    private let rectangleLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    private let footerLabel = UILabel()
    private let countLabel = UILabel()
    private var checkButton = UIButton()
    private let rectangleLabel = UILabel()
    private let titleLabel = UILabel()
    private let emojiLabel = UILabel()
    private var buttonStatus: Bool = false
    private var completedTrackersCount = 0
    private let trackersViewController = TrackersViewController()
    private var currentDate: Date = Date()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Actions
    
    @objc private func didTapCheckButton() {
        if currentDate <= Date() {
            if buttonStatus {
                checkButton.setImage(.buttonPlus, for: .normal)
                self.completedTrackersCount -= 1
                countLabel.text = trackersCountStringFormatter()
            } else {
                checkButton.setImage(.buttonCheckmark, for: .normal)
                self.completedTrackersCount += 1
                countLabel.text = trackersCountStringFormatter()
            }
            buttonStatus.toggle()
            delegate?.trackerCellCheckButtonDidTap(self, buttonStatus: buttonStatus)
        }
    }
    
    //MARK: - Methods
    
    func setNewCell(name: String, emoji: String, color: UIColor, checkButtonStatus: Bool, completedTrackersCount: Int, currentDate: Date) {
        self.completedTrackersCount = completedTrackersCount
        titleLabel.text = name
        emojiLabel.text = emoji
        rectangleLabel.layer.backgroundColor = color.cgColor
        checkButton.tintColor = color
        countLabel.text = trackersCountStringFormatter()
        buttonStatus = checkButtonStatus
        self.currentDate = currentDate
        checkButton.setImage(UIImage(resource: buttonStatus == true ? .buttonCheckmark: .buttonPlus), for: .normal)
    }
    
    func test() {
        footerLabel.isHidden = true
    }
    
    //MARK: - Private methods
    
    private func configureCell() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        configureRectangleLabel()
        configureTitleLabel()
        configureEmojiLabel()
        configureFooterLabel()
        configureCheckButton()
        configureCountLabel()
    }
    
    private func trackersCountStringFormatter() -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString("daysCount", comment: "Number of completed trackers"),
            self.completedTrackersCount)
    }
    
    
    private func configureRectangleLabel() {
        rectangleLabel.translatesAutoresizingMaskIntoConstraints = false
        rectangleLabel.layer.addSublayer(rectangleLayer)
        rectangleLabel.layer.cornerRadius = 16
        rectangleLabel.layer.masksToBounds = true
        contentView.addSubview(rectangleLabel)
        
        NSLayoutConstraint.activate([
            rectangleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rectangleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rectangleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            rectangleLabel.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    private func configureTitleLabel(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(resource: .ypWhiteFilterButton)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.numberOfLines = 0
        rectangleLabel.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: rectangleLabel.topAnchor, constant: 44),
            titleLabel.bottomAnchor.constraint(equalTo: rectangleLabel.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: rectangleLabel.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: rectangleLabel.trailingAnchor, constant: -12)
        ])
    }
    
    private func configureEmojiLabel() {
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.backgroundColor = .ypEmojiLabelColorIOS
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        rectangleLabel.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: rectangleLabel.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: rectangleLabel.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureFooterLabel() {
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.isUserInteractionEnabled = true
        addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            footerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            footerLabel.topAnchor.constraint(equalTo: rectangleLabel.bottomAnchor),
            footerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerLabel.heightAnchor.constraint(equalToConstant: 58),
            footerLabel.widthAnchor.constraint(equalToConstant: 167),
        ])
    }
    
    private func configureCheckButton() {
        checkButton = UIButton(type: .system)
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        checkButton.accessibilityIdentifier = "CheckButton"
        checkButton.tintColor = .red
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            checkButton.trailingAnchor.constraint(equalTo: footerLabel.trailingAnchor, constant: -12),
            checkButton.bottomAnchor.constraint(equalTo: footerLabel.bottomAnchor, constant: -16),
            checkButton.heightAnchor.constraint(equalToConstant: 34),
            checkButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    private func configureCountLabel() {
        countLabel.textColor = UIColor(named: "YP Black (iOS)")
        countLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: footerLabel.leadingAnchor, constant: 12),
            countLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
        ])
    }
}

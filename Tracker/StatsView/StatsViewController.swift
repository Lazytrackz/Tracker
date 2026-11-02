//
//  StatsViewController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 29.08.2026.
//


import UIKit

//MARK: - StatsViewController

final class StatsViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var titleLabel = UILabel()
    private var emptyStatsImage = UIImageView()
    private var emptyStatsLabel = UILabel()
    private var statsLabelStackView = UIStackView()
    private var statsViewModel = StatsViewModel()
    private var bestPeriodCount = StatsItemLabel()
    private var idealDaysCount = StatsItemLabel()
    private var completedTrackersCount = StatsItemLabel()
    private var averageCompletedTrackersCount = StatsItemLabel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateData()
    }
    
    //MARK: - Methods
    
    func updateData() {
        statsViewModel.onTasksUpdated = { [weak self] in
            self?.addCounts()
        }
        statsViewModel.updateCounts()
    }
    
    //MARK: - Private methods
    
    private func configureView() {
        self.view.backgroundColor = .ypWhiteIOS
        configureTitleLabel()
        configureEmptyStatsImage()
        configureEmptyStatsLabel()
        configureStatsLabelStackView()
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        let titleText = NSLocalizedString("view_statistics", comment: "Text for view title label")
        titleLabel.text = titleText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -105),
        ])
    }
    
    private func configureEmptyStatsLabel() {
        emptyStatsLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyStatsLabel.textColor = UIColor(resource: .ypBlackIOS)
        emptyStatsLabel.textAlignment = .center
        emptyStatsLabel.lineBreakMode = .byWordWrapping
        emptyStatsLabel.numberOfLines = 2
        emptyStatsLabel.adjustsFontSizeToFitWidth = false
        emptyStatsLabel.text = "Анализировать пока нечего"
        emptyStatsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStatsLabel)
        
        NSLayoutConstraint.activate([
            emptyStatsLabel.topAnchor.constraint(equalTo: emptyStatsImage.bottomAnchor, constant: 8),
            emptyStatsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyStatsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureEmptyStatsImage() {
        let image = UIImage(resource: .emptyStats)
        emptyStatsImage = UIImageView(image: image)
        emptyStatsImage.contentMode = .scaleAspectFit
        emptyStatsImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStatsImage)
        
        NSLayoutConstraint.activate([
            emptyStatsImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            emptyStatsImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 147),
            emptyStatsImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -148),
        ])
    }
    
    private func configureStatsLabelStackView() {
        statsLabelStackView.axis = .vertical
        statsLabelStackView.distribution = .fillProportionally
        statsLabelStackView.spacing = 10
        statsLabelStackView.alignment = .center
        statsLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        statsLabelStackView.addArrangedSubview(bestPeriodCount)
        statsLabelStackView.addArrangedSubview(idealDaysCount)
        statsLabelStackView.addArrangedSubview(completedTrackersCount)
        statsLabelStackView.addArrangedSubview(averageCompletedTrackersCount)
        view.addSubview(statsLabelStackView)
        
        NSLayoutConstraint.activate([
            statsLabelStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statsLabelStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statsLabelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
        ])
    }
    
    private func countItemsVisibility(_ isShow: Bool) {
        if isShow {
            emptyStatsImage.isHidden = true
            emptyStatsLabel.isHidden = true
            statsLabelStackView.isHidden = false
        }else {
            emptyStatsImage.isHidden = false
            emptyStatsLabel.isHidden = false
            statsLabelStackView.isHidden = true
        }
    }
    
    private func addCounts() {
        if statsViewModel.getCompletedTrackersCount() > 0 {
            countItemsVisibility(true)
            bestPeriodCount.configureItemLabel("Лучший период", String(statsViewModel.getbestPeriodCount()))
            idealDaysCount.configureItemLabel("Идеальные дни", String(statsViewModel.getIdealDaysCount()))
            completedTrackersCount.configureItemLabel("Трекеров завершено", String(statsViewModel.getCompletedTrackersCount()))
            averageCompletedTrackersCount.configureItemLabel("Среднее значение", String(statsViewModel.getAverageCompletedTrackersCount()))
        }else {
            countItemsVisibility(false)
        }
    }
}

//
//  ViewController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 29.08.2026.
//

import UIKit

//MARK: - TrackersViewController

final class TrackersViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private let datePicker = UIDatePicker()
    private let titleLabel: UILabel = UILabel()
    private var emptyTrackerImage: UIImageView = UIImageView()
    private let emptyTrackerLabel: UILabel = UILabel()
    private let addTrackerButton: UIButton = UIButton()
    private let searchBarLabel: UILabel = UILabel()
    private let searchBar: UISearchBar = UISearchBar()
    private var habitViewController: HabitViewController?
    private var collectionViewIsVisibility = false
    private var idSet = Set<UInt>()
    private var trackersHabitViewObserver: NSObjectProtocol?
    private var currentDate: Date = Date()
    
    private lazy var weekDaysdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    private lazy var recordsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitViewController = HabitViewController()
        configureView()
        observeTrackerCategory()
    }
    
    //MARK: - Actions
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        addTrackers()
    }
    
    @objc func didTapAddButton() {
        guard let habitViewController else { return }
        present(habitViewController, animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    
    private func configureView() {
        configureTitleLabel()
        configureSearchBar()
        configureEmptyTrackerLabel()
        configureEmptyTrackerImage()
        configureAddTrackerButton()
        configureDataPicker()
        configureCollectionView()
    }
    
    private func changeCollectionViewVisibility() {
        if collectionViewIsVisibility {
            collectionView.isHidden = false
            emptyTrackerImage.isHidden = true
            emptyTrackerLabel.isHidden = true
        }else {
            collectionView.isHidden = true
            emptyTrackerImage.isHidden = false
            emptyTrackerLabel.isHidden = false
        }
    }
    
    private func getRecordsData(date: Date) -> String {
        return recordsDateFormatter.string(from: date)
    }
    
    private func addTrackers() {
        
        changeCollectionViewVisibility()
        guard let categories = habitViewController?.getCategories() else { return}
        self.categories = categories
        guard categories.count != 0 else { return }
        let currentDateString: String = weekDaysdateFormatter.string(from: currentDate).capitalized
        
        var tempCategoryArray = [TrackerCategory]()
        var tempTrackerArray = [Tracker]()
        var trackersCount = 0
        
        categories.forEach { category in
            let categoryName = category.name
            category.trackers.forEach { tracker in
                if tracker.schedule.contains(where: { $0.rawValue == currentDateString}) {
                    tempTrackerArray.append(tracker)
                    trackersCount += 1
                }
            }
            let newCategory = TrackerCategory(name: categoryName, trackers: tempTrackerArray)
            tempCategoryArray.append(newCategory)
        }
        
        self.categories = tempCategoryArray
        updateCollectionView(trackersCount: trackersCount)
    }
    
    private func updateCollectionView(trackersCount: Int) {
        if trackersCount > 0 {
            collectionViewIsVisibility = true
            changeCollectionViewVisibility()
            collectionView.reloadData()
        }else {
            collectionViewIsVisibility = false
            changeCollectionViewVisibility()
        }
    }
    
    
    private func observeTrackerCategory() {
        trackersHabitViewObserver = NotificationCenter.default
            .addObserver(
                forName: HabitViewController.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                addTrackers()
            }
    }
    
    private func configureTrackerCell(for cell: TrackerCell, with indexPath: IndexPath) {
        let name = categories[indexPath.section].trackers[indexPath.row].name
        let color = categories[indexPath.section].trackers[indexPath.row].color
        let emoji = categories[indexPath.section].trackers[indexPath.row].emoji
        let trackerId = categories[indexPath.section].trackers[indexPath.row].id
        var checkButtonStatus = false
        var completedTrackersCount = 0
   
        if idSet.contains(trackerId) {
            if !completedTrackers.isEmpty{
                
                for tracker in completedTrackers {
                    if tracker.trackerId == trackerId {
                        completedTrackersCount += 1
                        if getRecordsData(date: currentDate) == getRecordsData(date: tracker.date) {
                            checkButtonStatus = true
                        }
                    }
                }
            }
        }
        
        cell.delegate = self
        cell.setNewCell(name: name ?? "", emoji: emoji, color: color, checkButtonStatus: checkButtonStatus, completedTrackersCount: completedTrackersCount, currentDate: self.currentDate)
    }
    
    private func configureCollectionView() {
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhiteIOS
        self.view.addSubview(collectionView)
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: Identifiers.trackerCellID)
        
        collectionView.register(CategoryCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.cellHeaderID)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        addTrackers()
    }
    
    private func configureSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.backgroundColor = .ypSearchBarColorIOS
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDataPicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        currentDate = datePicker.date
        
  
    }
    
    private func configureAddTrackerButton() {
        let addTrackerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        self.navigationItem.leftBarButtonItem = addTrackerButton
    }
    
    private func configureEmptyTrackerLabel() {
        
        emptyTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackerLabel.text = "Что будем отслеживать?"
        emptyTrackerLabel.textColor = UIColor(named: "YP Black (iOS)")
        emptyTrackerLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyTrackerLabel.textAlignment = .center
        view.addSubview(emptyTrackerLabel)
        
        NSLayoutConstraint.activate([
            emptyTrackerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -220),
            emptyTrackerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureEmptyTrackerImage() {
        let image = UIImage(named: "EmptyTrackerImage")
        emptyTrackerImage = UIImageView(image: image)
        emptyTrackerImage.contentMode = .scaleAspectFit
        emptyTrackerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyTrackerImage)
        
        NSLayoutConstraint.activate([
            emptyTrackerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackerImage.bottomAnchor.constraint(equalTo: emptyTrackerLabel.topAnchor, constant: -8)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.textColor = UIColor(named: "YP Black (iOS)")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
}

//MARK: - Extension

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiers.cellHeaderID, for: indexPath) as! CategoryCellHeader
        
        let name = categories[indexPath.section].name
        view.titleLabel.text = name
        view.titleLabel.textColor = UIColor(named: "YP Black (iOS)")
        view.titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.trackerCellID, for: indexPath) as? TrackerCell
        
        guard let cell else {
            print("Failed to load cell")
            return UICollectionViewCell()
        }
        configureTrackerCell(for: cell, with: indexPath)
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
}


extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 16, bottom: 1, right: 16)
    }
}

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, searchedTextDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func trackerCellCheckButtonDidTap(_ cell: TrackerCell, buttonStatus: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let trackerId = categories[indexPath.section].trackers[indexPath.row].id
        var countTrackers = 0

        if buttonStatus {
            let newTrackerRecord = TrackerRecord(trackerId: trackerId, date: currentDate)
            completedTrackers.append(newTrackerRecord)
            idSet.insert(trackerId)
            
        } else {
            for index in (0 ..< completedTrackers .count).reversed() {
                if completedTrackers[index].trackerId == trackerId {
                    countTrackers += 1
                    if getRecordsData(date: completedTrackers[index].date) == getRecordsData(date: currentDate){
                        completedTrackers.remove(at: index)
                    }
                }
            }
            if countTrackers == 1 {
                idSet.remove(trackerId)
            }
        }
    }
}

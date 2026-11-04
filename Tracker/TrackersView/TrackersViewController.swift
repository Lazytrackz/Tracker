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
    private let datePicker = UIDatePicker()
    private let titleLabel = UILabel()
    private var emptyTrackerImage = UIImageView()
    private let emptyTrackerLabel = UILabel()
    private let addTrackerButton  = UIButton()
    private let searchBarLabel = UILabel()
    private var habitViewController: HabitViewController?
    private var collectionViewIsVisibility = false
    private var idSet = Set<UInt>()
    private var trackersHabitViewObserver: NSObjectProtocol?
    private var currentDate: Date = Date()
    private var trackerViewModel = TrackersViewModel()
    private var searchField = UISearchTextField()
    private var filterButton = UIButton()
    private var filterViewController: FilterViewController?
    private var isSearchFilterOn = false
    private var isTrackersForTodayFilterIsOn = false
    private var isCompletedTrackersIsOn = false
    private var isIncompleteTrackersIsOn = false
    private let analyticsService = AnalyticsService()
    
    private var indexPath = IndexPath()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateView()
        searchField.delegate = self
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticsService.report(.open, screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(.close, screen: .main)
    }
    
    //MARK: - Actions
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        updateView()
    }
    
    @objc private func didTapAddButton() {
        self.habitViewController = HabitViewController()
        guard let habitViewController else { return }
        habitViewController.setLoadingViewStatus(isNewTracker: true)
        analyticsService.report(.click, screen: .main, item: .addTrack)
        
        present(habitViewController, animated: true, completion: nil)
    }
    
    @objc private func searchTextDidChange(_ searchField: UISearchTextField) {
        guard let text = searchField.text else { return }
        isSearchFilterOn = trackerViewModel.filterData(by: text)
        addTrackers()
    }
    
    @objc private func didTapFilterButton() {
        filterViewController = FilterViewController()
        filterViewController?.delegate = self
        guard let filterViewController else { return }
        analyticsService.report(.click, screen: .main, item: .filter)
        present(filterViewController, animated: true)
    }
    
    //MARK: - Private methods
    
    private func updateView() {
        if !isSearchFilterOn {
            trackerViewModel.onTasksUpdated = { [weak self] in
                self?.addTrackers()
            }
            trackerViewModel.setData(currentDate)
            trackerViewModel.updateCollection()
        } else {
            trackerViewModel.setData(currentDate)
            trackerViewModel.updateCollection()
            isSearchFilterOn = trackerViewModel.filterData(by: searchField.text ?? "")
            addTrackers()
        }
    }
    
    private func configureView() {
        self.view.backgroundColor = .ypWhiteIOS
        configureTitleLabel()
        configureSearchBar()
        configureEmptyTrackerLabel()
        configureEmptyTrackerImage()
        configureAddTrackerButton()
        configureDataPicker()
        configureCollectionView()
        configureFilterButton()
    }
    
    private func changeCollectionViewVisibility() {
        if collectionViewIsVisibility {
            collectionView.isHidden = false
            filterButton.isHidden = false
            emptyTrackerImage.isHidden = true
            emptyTrackerLabel.isHidden = true
        }else {
            collectionView.isHidden = true
            filterButton.isHidden = true
            
            let filter = isSearchFilterOn || isCompletedTrackersIsOn || isIncompleteTrackersIsOn || isTrackersForTodayFilterIsOn
            
            if filter {
                emptyTrackerImage.image = UIImage(resource: .filter)
                emptyTrackerLabel.text = "Ничего не найдено"
                filterButton.isHidden = false
                isTrackersForTodayFilterIsOn ? isTrackersForTodayFilterIsOn = false : nil
            }else {
                emptyTrackerImage.image = UIImage(resource: .emptyTracker)
                emptyTrackerLabel.text = "Что будем отслеживать?"
            }
            emptyTrackerImage.isHidden = false
            emptyTrackerLabel.isHidden = false
        }
    }
    
    private func addTrackers() {
        changeCollectionViewVisibility()
        let isTrackerFound = trackerViewModel.findTrackers()
        updateCollectionView(isTrackerFound)
    }
    
    private func setFilter(_ filterType: String) {
        switch filterType {
        case FilterType.trackersForToday.rawValue:
            datePicker.date = Date()
            currentDate = datePicker.date
            isTrackersForTodayFilterIsOn = true
            resetFilters()
        case FilterType.completedTrackers.rawValue:
            isCompletedTrackersIsOn = true
            filterButton.setTitleColor(.ypAlertColorIOS, for: .normal)
        case FilterType.incompleteTrackers.rawValue:
            isIncompleteTrackersIsOn = true
            filterButton.setTitleColor(.ypAlertColorIOS, for: .normal)
        case FilterType.allTrackers.rawValue:
            resetFilters()
        default:
            resetFilters()
        }
    }
    
    private func resetFilters() {
        isCompletedTrackersIsOn = false
        isIncompleteTrackersIsOn = false
        filterButton.setTitleColor(.ypWhiteFilterButton, for: .normal)
    }
    
    private func updateCollectionView(_ isTrackerFound: Bool) {
        if isTrackerFound {
            collectionViewIsVisibility = true
            changeCollectionViewVisibility()
            collectionView.reloadData()
        }else {
            collectionViewIsVisibility = false
            changeCollectionViewVisibility()
        }
    }
    
    private func configureTrackerCell(for cell: TrackerCell, with indexPath: IndexPath) {
        let name = trackerViewModel.getTracker(at: indexPath.section, at: indexPath.row).name
        let color = trackerViewModel.getTracker(at: indexPath.section, at: indexPath.row).color
        let emoji = trackerViewModel.getTracker(at: indexPath.section, at: indexPath.row).emoji
        let trackerId = trackerViewModel.getTracker(at: indexPath.section, at: indexPath.row).id
        let completedTrackers = trackerViewModel.checkCompletedTrackers(trackerId)
        
        cell.delegate = self
        cell.setNewCell(name: name ?? "", emoji: emoji, color: color, checkButtonStatus: completedTrackers.completedForCurrentDate, completedTrackersCount: completedTrackers.completedTrackersCount, currentDate: self.currentDate)
    }
    
    private func configureCollectionView() {
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhiteIOS
        collectionView.alwaysBounceVertical = true
        self.view.addSubview(collectionView)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: Identifiers.trackerCellID)
        collectionView.register(CategoryCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.cellHeaderID)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.searchField.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureSearchBar() {
        searchField.placeholder = "Поиск"
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.autocapitalizationType = .none
        searchField.autocorrectionType = .no
        searchField.backgroundColor = .ypSearchBarColorIOS
        searchField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
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
        let image = UIImage(resource: .emptyTracker)
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
        let titleText = NSLocalizedString("view_trackers", comment: "Text for label title")
        titleLabel.text = titleText
        titleLabel.textColor = UIColor(named: "YP Black (iOS)")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureFilterButton() {
        
        filterButton = UIButton(type: .roundedRect)
        filterButton.backgroundColor = .ypBlueIOS
        let buttonText = NSLocalizedString("view_filters", comment: "Text for filter button")
        filterButton.setTitle(buttonText, for: .normal)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        filterButton.setTitleColor(.ypWhiteFilterButton, for: .normal)
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        filterButton.layer.cornerRadius = 16
        filterButton.layer.masksToBounds = true
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -130),
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 130),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -66),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: - Extension

extension TrackersViewController: UICollectionViewDataSource {
    
    //MARK: - Methods
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiers.cellHeaderID, for: indexPath) as! CategoryCellHeader
        
        let name = trackerViewModel.getCategory(at: indexPath.section)
        view.titleLabel.text = name
        view.titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        view.titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = trackerViewModel.getTrackersCount(at: section)
        return count
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
    
    //MARK: - Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = trackerViewModel.getCategoriesCount()
        return count
    }
    
    func collectionView(_: UICollectionView, willEndContextMenuInteraction: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        guard let cell = collectionView.cellForItem(at: self.indexPath) as? TrackerCell else { return }
        cell.bounds.size.height = 148
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let categoryName = trackerViewModel.getCategory(at: indexPath.section)
        let tracker = trackerViewModel.getTracker(at: indexPath.section, at: indexPath.row)
        let completedTrackerCount = trackerViewModel.checkCompletedTrackers(tracker.id).completedTrackersCount
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
        self.indexPath = indexPath
        cell.bounds.size.height = 90
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let editAction = UIAction(title: "Редактировать", identifier: nil) { _ in
                self.trackerViewModel.saveExistingTracker(tracker)
                self.trackerViewModel.saveCategoryName(categoryName)
                self.trackerViewModel.saveCompletedTrackerCount(completedTrackerCount)
                self.habitViewController = HabitViewController()
                self.habitViewController?.setLoadingViewStatus(isNewTracker: false)
                guard let view = self.habitViewController else { return }
                self.analyticsService.report(.click, screen: .main, item: .edit)
                self.present(view, animated: true)
            }
            
            let deleteAction = UIAction(title: "Удалить", identifier: nil) { _ in
                let alertController = UIAlertController(title: "",
                                                        message: "Уверены что хотите удалить трекер?",
                                                        preferredStyle: .actionSheet)
                self.analyticsService.report(.click, screen: .main, item: .delete)
                
                let confirmAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                    self.trackerViewModel.deleteTrackerRecord(tracker.id)
                    self.trackerViewModel.deleteTracker(tracker.id)
                    self.updateView()
                }
                
                let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
            
            let attributedTitle = NSAttributedString(
                string: "Удалить",
                attributes: [
                    .foregroundColor: UIColor(resource: .ypAlertColorIOS)
                ]
            )
            deleteAction.setValue(attributedTitle, forKey: "attributedTitle")
            return UIMenu(image: nil, identifier: nil,
                          options: UIMenu.Options.displayInline,
                          children: [editAction, deleteAction])
        }
        
        return configuration
    }
    
    
  
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Methods
    
    
    
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

extension TrackersViewController: UITextFieldDelegate{
    
    //MARK: - Methods
    
    func textFieldShouldReturn(_ searchField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}

extension TrackersViewController: TrackerCellDelegate {
    
    //MARK: - Methods
    
    func trackerCellCheckButtonDidTap(_ cell: TrackerCell, buttonStatus: Bool) {
        analyticsService.report(.click, screen: .main, item: .track)
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let trackerId = trackerViewModel.getTracker(at: indexPath.section, at: indexPath.row).id
        let newTrackerRecord = TrackerRecord(trackerId: trackerId, date: currentDate)
        if buttonStatus {
            trackerViewModel.addRecord(newTrackerRecord)
            updateView()
        } else {
            trackerViewModel.deleteRecord(newTrackerRecord)
            updateView()
        }
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    
    //MARK: - Methods
    
    func didUpdate() {
        addTrackers()
    }
}

extension TrackersViewController: FilterViewControllerDelegate {
    
    //MARK: - Methods
    
    func updateFilter(_ filterType: String) {
        setFilter(filterType)
        updateView()
    }
}

extension TrackersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let bottomInset = scrollView.contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        
        if !collectionView.isHidden{
            if scrollView.contentOffset.y > scrollViewBottomOffset && scrollView.contentOffset.y != 0   {
                filterButton.isHidden = true
            }else {
                filterButton.isHidden = false
            }
        }
    }
}

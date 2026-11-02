//
//  HabitViewController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 07.09.2026.
//

import UIKit
import CoreData

//MARK: - HabitViewController

final class HabitViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var habitViewModel = HabitViewModel()
    private let titleLabel: UILabel = UILabel()
    private var trackerNameTextField: UITextField = UITextField()
    private var trackerNameLabel: UILabel = UILabel()
    private var createTrackerButton: UIButton = UIButton()
    private var cancelTrackerButton: UIButton = UIButton()
    private var scheduleButton: UIButton = UIButton()
    private var scheduleButtonLabel: UILabel = UILabel()
    private var categoryButton: UIButton = UIButton()
    private var categoryButtonLabel: UILabel = UILabel()
    private var stackView: UIStackView = UIStackView()
    private var trackerId: UInt = 0
    private var isScheduleCreated: Bool = false
    private var isCategoryChosen: Bool = false
    private var isTrackerNameCreated: Bool = false
    private var isEmojiSelected: Bool = false
    private var isColorSelected: Bool = false
    private var scheduleArray = [WeekDays]()
    private var scheduleViewController: TrackerScheduleView?
    private var categoryViewController =  CategoryViewController()
    private var trackerEmoji = String()
    private var trackerColor = UIColor()
    private var emojiTitleLabel = UILabel()
    private var emojiCollection = Smiles.smilesCollection
    private let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var colorTitleLabel = UILabel()
    private var colorCollection = [UIColor.colorSelection1, UIColor.colorSelection2, UIColor.colorSelection3, UIColor.colorSelection4, UIColor.colorSelection5, UIColor.colorSelection6, UIColor.colorSelection7, UIColor.colorSelection8, UIColor.colorSelection9, UIColor.colorSelection10, UIColor.colorSelection11, UIColor.colorSelection12, UIColor.colorSelection13, UIColor.colorSelection14, UIColor.colorSelection15, UIColor.colorSelection16, UIColor.colorSelection17, UIColor.colorSelection18]
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var scroll = UIScrollView()
    private var mainView = UIView()
    private var trackerCategoryName: String?
    private var categoryButtonStackView = UIStackView()
    private var scheduleButtonStackView = UIStackView()
    private var showCategoryLabel = UILabel()
    private var scheduleLabel = UILabel()
    private var completedDaysLabel = UILabel()
    private var isNewTracker = false
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNewTracker ? configuredViewForNewTracker() : configuredViewForExistingTracker()
    }
    
    // MARK: - Actions
    
    @objc private func didTapCreateButton() {
        isNewTracker ? createTracker() : rewriteTracker()
        clearData()
        checkCreateButtonStatus()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancelButton() {
        clearData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCategoryButton() {
        categoryViewController.delegate = self
        present(categoryViewController, animated: true, completion: nil)
        
    }
    
    @objc private func didTapScheduleButton() {
        scheduleViewController = TrackerScheduleView()
        guard let scheduleViewController else { return }
        scheduleViewController.delegate = self
        present(scheduleViewController, animated: true, completion: nil)
    }
    
    // MARK: - methods
    
    func setLoadingViewStatus(isNewTracker: Bool) {
        self.isNewTracker = isNewTracker
    }
    
    // MARK: - Private methods
    
    private func configuredViewForNewTracker() {
        configureScroll()
        configureMainView()
        configureTitle("Новая привычка")
        configureTrackerNameLabel()
        configureTrackerNameTextField()
        configureCreateTrackerButton("Создать")
        configureCancelTrackerButton()
        configureScheduleButton()
        configureCategoryButton()
        configureButtonsContainer()
        configureEmojiTitleLabel()
        configureEmojiCollectionView()
        configureColorTitleLabel()
        configureColorCollectionView()
    }
    
    private func configuredViewForExistingTracker() {
        configureScroll()
        configureMainView()
        configureTitle("Редактирование привычки")
        configureCompletedDaysLabel()
        configureTrackerNameLabel()
        configureTrackerNameTextField()
        configureCreateTrackerButton("Сохранить")
        configureCancelTrackerButton()
        configureScheduleButton()
        configureCategoryButton()
        configureButtonsContainer()
        configureEmojiTitleLabel()
        configureEmojiCollectionView()
        configureColorTitleLabel()
        configureColorCollectionView()
        
        updateView()
        
    }
    
    private func updateView() {
        habitViewModel.categoryUpdated = { [weak self] in
            self?.setCategory()
        }
        habitViewModel.trackerUpdated = { [weak self] in
            self?.setTracker()
        }
        habitViewModel.completedTrackerCountUpdated = { [weak self ] in
            self?.setCompletedTrackerCount()}
        
        habitViewModel.updateHabitView()
    }
    
    private func setCategory(){
        guard let name = habitViewModel.getCategoryName() else { return }
        showCategoryLabel(name)
    }
    
    private func setTracker(){
        guard let trackerName = habitViewModel.getTracker()?.name else { return }
        guard let schedule = habitViewModel.getTracker()?.schedule else { return }
        
        trackerNameTextField.text = trackerName
        trackerTextFieldCompleted()
        showScheduleLabel(schedule)
        
    }
    
    private func setCompletedTrackerCount(){
        guard let completedTrackersDays = habitViewModel.getCompletedTrackerCount() else { return }
        let countTrackersString = String.localizedStringWithFormat(
            NSLocalizedString("daysCount", comment: "Number of completed trackers"),
            completedTrackersDays
        )
        completedDaysLabel.text = countTrackersString
    }
    
    private func showCategoryLabel(_ categoryName: String) {
        trackerCategoryName = categoryName
        isCategoryChosen = true
        checkCreateButtonStatus()
        guard let trackerCategoryName else { return }
        configureShowCategoryLabel(trackerCategoryName)
        categoryButtonStackView.addArrangedSubview(showCategoryLabel)
    }
    
    private func showScheduleLabel(_ scheduleArray: [WeekDays]) {
        self.scheduleArray = scheduleArray
        isScheduleCreated = true
        checkCreateButtonStatus()
        if !self.scheduleArray.isEmpty {
            let dayList = convertWeekDays(self.scheduleArray)
            configureShowScheduleLabel(dayList)
            scheduleButtonStackView.addArrangedSubview(scheduleLabel)
        }
    }
    
    private func setSelectedEmoji(_ cell: EmojiCollectionCell, _ indexPath: IndexPath) {
        isEmojiSelected = true
        cell.setEmojiLabelColorStatus(isEmojiSelected)
        trackerEmoji = emojiCollection[indexPath.row]
        checkCreateButtonStatus()
    }
    
    private func setDeselectedEmoji(_ cell: EmojiCollectionCell, _ indexPath: IndexPath) {
        isEmojiSelected = false
        cell.setEmojiLabelColorStatus(isEmojiSelected)
        checkCreateButtonStatus()
    }
    
    private func setSelectedColor(_ cell: ColorCollectionCell, _ indexPath: IndexPath) {
        isColorSelected = true
        cell.setBorderLabelColorStatus(isColorSelected)
        trackerColor = colorCollection[indexPath.row]
        checkCreateButtonStatus()
    }
    
    private func setDeselectedColor(_ cell: ColorCollectionCell, _ indexPath: IndexPath) {
        isColorSelected = false
        cell.setBorderLabelColorStatus(isColorSelected)
        checkCreateButtonStatus()
    }
    
    private func deselectEmojiCell(_ collectionView: UICollectionView) {
        var indexPath: IndexPath?
        guard let emoji = habitViewModel.getTracker()?.emoji else { return }
        
        for (index, currentEmoji) in emojiCollection.enumerated() {
            if currentEmoji == emoji {
                indexPath = IndexPath(item: index, section: 0)
            }
        }
        guard let indexPath else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionCell else { return }
        setDeselectedEmoji(cell, indexPath)
    }
    
    private func deselectColorCell(_ collectionView: UICollectionView) {
        var indexPath: IndexPath?
        guard let color = habitViewModel.getTracker()?.color else { return }
        
        for (index, currentColor) in colorCollection.enumerated() {
            if currentColor == color {
                indexPath = IndexPath(item: index, section: 0)
            }
        }
        guard let indexPath else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionCell else { return }
        setDeselectedColor(cell, indexPath)
    }
    
    private func trackerTextFieldCompleted() {
        isTrackerNameCreated = true
        checkCreateButtonStatus()
    }
    
    private func configureCompletedDaysLabel() {
        completedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        completedDaysLabel.textColor = UIColor(resource: .ypBlackIOS)
        completedDaysLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        completedDaysLabel.text = " дней"
        completedDaysLabel.textAlignment = .center
        mainView.addSubview(completedDaysLabel)
        
        NSLayoutConstraint.activate([
            completedDaysLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 38),
            completedDaysLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            completedDaysLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureScroll() {
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureMainView() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scroll.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            mainView.widthAnchor.constraint(equalTo: scroll.widthAnchor)
        ])
    }
    
    private func configureColorTitleLabel() {
        colorTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorTitleLabel.textColor = UIColor(named: "YP Black (iOS)")
        colorTitleLabel.text = "Цвет"
        colorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(colorTitleLabel)
        
        NSLayoutConstraint.activate([
            colorTitleLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorTitleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 28)
        ])
    }
    
    private func configureColorCollectionView() {
        colorCollectionView.allowsMultipleSelection = false
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.backgroundColor = .ypWhiteIOS
        colorCollectionView.isScrollEnabled = false
        mainView.addSubview(colorCollectionView)
        colorCollectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: Identifiers.colorCellID)
        
        NSLayoutConstraint.activate([
            colorCollectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: createTrackerButton.topAnchor),
            colorCollectionView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204)
        ])
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
    
    private func configureColorCell(cell: ColorCollectionCell, indexPath: IndexPath) {
        let color = colorCollection[indexPath.row]
        cell.setNewCell(color: color)
        
        if !isNewTracker {
            guard let selectedColor = habitViewModel.getTracker()?.color else { return }
            if selectedColor == colorCollection[indexPath.row] {
                setSelectedColor(cell, indexPath)
            }
        }
    }
    
    private func configureEmojiCell(cell: EmojiCollectionCell, indexPath: IndexPath) {
        let emoji = emojiCollection[indexPath.row]
        cell.setNewCell(emoji: emoji)
        
        if !isNewTracker {
            guard let selectedEmoji = habitViewModel.getTracker()?.emoji else { return }
            if selectedEmoji == emojiCollection[indexPath.row] {
                setSelectedEmoji(cell, indexPath)
            }
        }
    }
    
    private func configureEmojiTitleLabel() {
        emojiTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiTitleLabel.textColor = UIColor(resource: .ypBlackIOS)
        emojiTitleLabel.text = "Emoji"
        emojiTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(emojiTitleLabel)
        
        NSLayoutConstraint.activate([
            emojiTitleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 28)
        ])
    }
    
    private func configureEmojiCollectionView() {
        emojiCollectionView.allowsMultipleSelection = false
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.backgroundColor = .ypWhiteIOS
        emojiCollectionView.isScrollEnabled = false
        mainView.addSubview(emojiCollectionView)
        emojiCollectionView.register(EmojiCollectionCell.self, forCellWithReuseIdentifier: Identifiers.emojiCellID)
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
        ])
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
    }
    
    private func clearData() {
        trackerNameTextField.text = ""
        trackerEmoji = ""
        completedDaysLabel.text = ""
        scheduleLabel.removeFromSuperview()
        showCategoryLabel.removeFromSuperview()
        isScheduleCreated = false
        isCategoryChosen = false
        isTrackerNameCreated = false
        isEmojiSelected = false
        isColorSelected = false
        emojiCollectionView.reloadData()
        colorCollectionView.reloadData()
        habitViewModel.deleteAllData()
    }
    
    private func checkCreateButtonStatus() {
        let isEnabled: Bool = isScheduleCreated && isTrackerNameCreated && isEmojiSelected && isColorSelected && isCategoryChosen
        createTrackerButton.backgroundColor = isEnabled ? .ypBlackIOS : .ypGrayIOS
        createTrackerButton.isEnabled = isEnabled
    }
    
    private func createTracker() {
        trackerId += 1
        let trackerName = trackerNameTextField.text
        let tracker = Tracker(id: trackerId, name: trackerName, color: trackerColor, emoji: trackerEmoji, schedule: scheduleArray)
        guard let trackerCategoryName else { return }
        habitViewModel.createTracker(tracker, trackerCategoryName)
    }
    
    private func rewriteTracker() {
        guard let trackerId = habitViewModel.getTracker()?.id else { return }
        let trackerName = trackerNameTextField.text
        let tracker = Tracker(id: trackerId, name: trackerName, color: trackerColor, emoji: trackerEmoji, schedule: scheduleArray)
        guard let trackerCategoryName else { return }
        habitViewModel.rewriteExistingTracker(tracker, trackerCategoryName)
    }
    
    
    private func configureScheduleButtonStackView() {
        scheduleButtonStackView.addArrangedSubview(scheduleButtonLabel)
        scheduleButtonStackView.axis = .vertical
        scheduleButtonStackView.distribution = .equalCentering
        scheduleButtonStackView.spacing = 2
        scheduleButtonStackView.alignment = .leading
        scheduleButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.addSubview(scheduleButtonStackView)
        
        NSLayoutConstraint.activate([
            scheduleButtonStackView.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
            scheduleButtonStackView.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 15),
            scheduleButtonStackView.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -14),
        ])
    }
    
    private func configureScheduleButtonLabel() {
        scheduleButtonLabel.text = "Расписание"
        scheduleButtonLabel.textColor = UIColor(resource: .ypBlackIOS)
        scheduleButtonLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        scheduleButtonLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCategoryButtonLabel() {
        categoryButtonLabel.text = "Категория"
        categoryButtonLabel.textColor = UIColor(resource: .ypBlackIOS)
        categoryButtonLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        categoryButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addSubview(categoryButtonLabel)
    }
    
    private func configureTrackerNameLabel() {
        trackerNameLabel.layer.cornerRadius = 16
        trackerNameLabel.layer.masksToBounds = true
        trackerNameLabel.backgroundColor = .ypBackgroundIOS
        trackerNameLabel.isUserInteractionEnabled = true
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(trackerNameLabel)
        
        
        if isNewTracker {
            NSLayoutConstraint.activate([
                trackerNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
                trackerNameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
                trackerNameLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
                trackerNameLabel.heightAnchor.constraint(equalToConstant: 75),
            ])
        }else {
            NSLayoutConstraint.activate([
                trackerNameLabel.topAnchor.constraint(equalTo: completedDaysLabel.bottomAnchor, constant: 40),
                trackerNameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
                trackerNameLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
                trackerNameLabel.heightAnchor.constraint(equalToConstant: 75),
            ])
        }
    }
    
    private func configureTrackerNameTextField() {
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.isEnabled = true
        trackerNameTextField.isUserInteractionEnabled = true
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.resignFirstResponder()
        trackerNameTextField.delegate = self
        trackerNameLabel.addSubview(trackerNameTextField)
        
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: trackerNameLabel.topAnchor, constant: 27),
            trackerNameTextField.bottomAnchor.constraint(equalTo: trackerNameLabel.bottomAnchor, constant: -26),
            trackerNameTextField.leadingAnchor.constraint(equalTo: trackerNameLabel.leadingAnchor, constant: 16),
        ])
    }
    
    private func configureButtonIcon(_ button: UIButton) {
        let buttonIcon = UIImage(named: "ButtonIcon")
        let buttonImageView = UIImageView()
        buttonImageView.image = buttonIcon
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(buttonImageView)
        
        NSLayoutConstraint.activate([
            buttonImageView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -16),
            buttonImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
        ])
    }
    
    private func configureButtonsContainer() {
        stackView = UIStackView(arrangedSubviews: [categoryButton, scheduleButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: trackerNameLabel.bottomAnchor, constant: 24),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            stackView.widthAnchor.constraint(equalToConstant: 343),
        ])
    }
    
    private func configureScheduleButton() {
        scheduleButton = UIButton(type: .roundedRect)
        configureButtonIcon(scheduleButton)
        scheduleButton.backgroundColor = .ypBackgroundIOS
        scheduleButton.setTitleColor(.ypBlackIOS, for: .normal)
        scheduleButton.addTarget(self, action: #selector(didTapScheduleButton), for: .touchUpInside)
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        configureScheduleButtonLabel()
        configureScheduleButtonStackView()
        
    }
    
    private func configureCategoryButton() {
        categoryButton = UIButton(type: .roundedRect)
        configureButtonIcon(categoryButton)
        categoryButton.backgroundColor = .ypBackgroundIOS
        categoryButton.setTitleColor(.ypBlackIOS, for: .normal)
        categoryButton.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        configureCategoryButtonLabel()
        configureCategoryButtonStackView()
        
    }
    
    private func configureShowCategoryLabel(_ categoryName: String) {
        showCategoryLabel.text = categoryName
        showCategoryLabel.textColor = UIColor(resource: .ypGrayIOS)
        showCategoryLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        showCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureShowScheduleLabel(_ schedule: String) {
        scheduleLabel.text = schedule
        scheduleLabel.textColor = UIColor(resource: .ypGrayIOS)
        scheduleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureCategoryButtonStackView() {
        categoryButtonStackView.addArrangedSubview(categoryButtonLabel)
        categoryButtonStackView.axis = .vertical
        categoryButtonStackView.distribution = .equalCentering
        categoryButtonStackView.spacing = 2
        categoryButtonStackView.alignment = .leading
        categoryButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addSubview(categoryButtonStackView )
        
        NSLayoutConstraint.activate([
            categoryButtonStackView.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            categoryButtonStackView.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 15),
            categoryButtonStackView.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -14),
        ])
    }
    
    private func configureCancelTrackerButton() {
        cancelTrackerButton = UIButton(type: .roundedRect)
        cancelTrackerButton.backgroundColor = .ypWhiteIOS
        cancelTrackerButton.layer.borderColor = UIColor.ypRedIOS.cgColor
        cancelTrackerButton.layer.borderWidth = 1
        cancelTrackerButton.setTitle("Отменить", for: .normal)
        cancelTrackerButton.setTitleColor(.ypRedIOS, for: .normal)
        cancelTrackerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        //cancelTrackerButton.titleLabel?.textColor = UIColor(resource: .ypRedIOS)
        cancelTrackerButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelTrackerButton.layer.cornerRadius = 16
        cancelTrackerButton.layer.masksToBounds = true
        cancelTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(cancelTrackerButton)
        
        NSLayoutConstraint.activate([
            cancelTrackerButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            cancelTrackerButton.centerYAnchor.constraint(equalTo: createTrackerButton.centerYAnchor),
            cancelTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            cancelTrackerButton.widthAnchor.constraint(equalToConstant: 161),
        ])
    }
    
    private func configureCreateTrackerButton(_ buttonName: String) {
        createTrackerButton = UIButton(type: .roundedRect)
        createTrackerButton.backgroundColor = .ypGrayIOS
        createTrackerButton.setTitle(buttonName, for: .normal)
        createTrackerButton.setTitleColor(.ypWhiteIOS, for: .normal)
        createTrackerButton.setTitleColor(.ypWhiteFilterButton, for: .disabled)
        createTrackerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createTrackerButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createTrackerButton.layer.cornerRadius = 16
        createTrackerButton.layer.masksToBounds = true
        checkCreateButtonStatus()
        createTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(createTrackerButton)
        
        NSLayoutConstraint.activate([
            createTrackerButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            createTrackerButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            createTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            createTrackerButton.widthAnchor.constraint(equalToConstant: 161),
        ])
    }
    
    private func configureTitle(_ titleName: String) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.text = titleName
        titleLabel.textAlignment = .center
        mainView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 38),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 79),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -78)
        ])
    }
    
    private func convertWeekDays(_ weekDays: [WeekDays]) -> String {
        var convertedDays: String = ""
        let weekDayNumbers: [WeekDays: Int] = [
            WeekDays.sunday: 6,
            WeekDays.monday: 0,
            WeekDays.tuesday: 1,
            WeekDays.wednesday: 2,
            WeekDays.thursday: 3,
            WeekDays.friday: 4,
            WeekDays.saturday: 5
        ]
        
        let sortedDays = weekDays.sorted(by: {
            weekDayNumbers[$0] ?? 7 < weekDayNumbers[$1] ?? 7
        })
        
        for day in sortedDays{
            switch day {
            case .monday:
                convertedDays.append("Пн, ")
            case .tuesday:
                convertedDays.append("Вт, ")
            case .wednesday:
                convertedDays.append("Ср, ")
            case .thursday:
                convertedDays.append("Чт, ")
            case .friday:
                convertedDays.append("Пт, ")
            case .saturday:
                convertedDays.append("Cб, ")
            case .sunday:
                convertedDays.append("Вс, ")
            }
        }
        convertedDays.removeLast(2)
        return convertedDays
    }
}

//MARK: - Extension

extension HabitViewController: ScheduleViewDelegate {
    
    //MARK: - Methods
    
    func scheduleViewDoneButtonDidTap(scheduleArray: [WeekDays]) {
        showScheduleLabel(scheduleArray)
    }
}

extension HabitViewController: UITextFieldDelegate {
    
    //MARK: - Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        trackerTextFieldCompleted()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cancelTrackerButton.isEnabled = false
        scheduleButton.isEnabled = false
        categoryButton.isEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelTrackerButton.isEnabled = true
        scheduleButton.isEnabled = true
        categoryButton.isEnabled = true
    }
}

extension HabitViewController: UICollectionViewDataSource {
    
    //MARK: - Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == emojiCollectionView  ? emojiCollection.count : colorCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.emojiCellID, for: indexPath) as? EmojiCollectionCell
            guard let cell else {
                print("Failed to load cell")
                return UICollectionViewCell()
            }
            configureEmojiCell(cell: cell, indexPath: indexPath)
            return cell
        } else {
            let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.colorCellID, for: indexPath) as? ColorCollectionCell
            guard let cell else {
                print("Failed to load cell")
                return UICollectionViewCell()
            }
            configureColorCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
}

extension HabitViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
    
}

extension HabitViewController: UICollectionViewDelegate {
    
    //MARK: - Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionCell else { return }
            
            if !isNewTracker {
                deselectEmojiCell(collectionView)
            }
            
            setSelectedEmoji(cell, indexPath)
            
        }else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionCell else { return }
            if !isNewTracker {
                deselectColorCell(collectionView)
            }
            setSelectedColor(cell, indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionCell else { return }
            setDeselectedEmoji(cell, indexPath)
        }else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionCell else { return }
            setDeselectedColor(cell, indexPath)
        }
    }
}

extension HabitViewController: CategoryViewControllerDelegate {
    
    //MARK: - Methods
    
    func setCategory(_ categoryName: String) {
        showCategoryLabel(categoryName)
    }
}

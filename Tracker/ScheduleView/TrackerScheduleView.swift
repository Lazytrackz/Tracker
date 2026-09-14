//
//  TrackerScheduleView.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 11.09.2026.
//

import UIKit

//MARK: - TrackerScheduleView

final class TrackerScheduleView: UIViewController {
    
    //MARK: - Delegate
    
    weak var delegate: ScheduleViewDelegate!
    
    //MARK: - Private properties
    
    private let titleLabel: UILabel = UILabel()
    private var doneButton: UIButton = UIButton()
    private var stackView: UIStackView = UIStackView()
    private var switches = [UILabel]()
    private var scheduleArray = [WeekDays]()
    private var scheduleMap = [Int: Bool]()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //MARK: - Actions
    
    @objc func didTapDoneButton() {
        if !scheduleMap.isEmpty {
            scheduleMap.forEach { key, value in
                
                switch key {
                case 0:
                    value == true ? scheduleArray.append(WeekDays.monday): scheduleArray.removeAll(where: {$0 == WeekDays.monday})
                case 1:
                    value == true ? scheduleArray.append(WeekDays.tuesday): scheduleArray.removeAll(where: {$0 == WeekDays.tuesday})
                case 2:
                    value == true ? scheduleArray.append(WeekDays.wednesday): scheduleArray.removeAll(where: {$0 == WeekDays.wednesday})
                case 3:
                    value == true ? scheduleArray.append(WeekDays.thursday): scheduleArray.removeAll(where: {$0 == WeekDays.thursday})
                case 4:
                    value == true ? scheduleArray.append(WeekDays.friday): scheduleArray.removeAll(where: {$0 == WeekDays.friday})
                case 5:
                    value == true ? scheduleArray.append(WeekDays.saturday): scheduleArray.removeAll(where: {$0 == WeekDays.saturday})
                case 6:
                    value == true ? scheduleArray.append(WeekDays.sunday): scheduleArray.removeAll(where: {$0 == WeekDays.sunday})
                default:
                    scheduleArray.removeAll()
                }
            }
        }
        let tempScheduleArray = scheduleArray
        delegate.scheduleViewDoneButtonDidTap(scheduleArray: tempScheduleArray)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        scheduleMap[sender.tag] = sender.isOn
    }
    
    //MARK: - Private methods
    
    private func configureView() {
        configureTitle()
        configureDoneButton()
        configureSwitch()
        configureSwitchContainer()
    }
    
    private func configureTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = "Расписание"
        titleLabel.textColor = UIColor(named: "YP Black (iOS)")
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 140),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -138)
        ])
    }
    
    private func configureSwitch() {
        let numberOfSwitches = 7
        for i in 0..<numberOfSwitches {
            let labelContainer = UILabel()
            labelContainer.backgroundColor = .ypBackgroundIOS
            labelContainer.translatesAutoresizingMaskIntoConstraints = false
            labelContainer.isUserInteractionEnabled = true
            
            labelContainer.textColor = UIColor(named: "YP Black (iOS)")
            labelContainer.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            let switchLabel = UILabel()
            switchLabel.translatesAutoresizingMaskIntoConstraints = false
            switchLabel.font = UIFont.systemFont(ofSize: 17)
            switchLabel.backgroundColor = .ypBackgroundIOS
            switchLabel.isUserInteractionEnabled = true
            
            switch i {
            case 0:
                switchLabel.text = WeekDays.monday.rawValue
            case 1:
                switchLabel.text =  WeekDays.tuesday.rawValue
            case 2:
                switchLabel.text = WeekDays.wednesday.rawValue
            case 3:
                switchLabel.text = WeekDays.thursday.rawValue
            case 4:
                switchLabel.text = WeekDays.friday.rawValue
            case 5:
                switchLabel.text = WeekDays.saturday.rawValue
            case 6:
                switchLabel.text = WeekDays.sunday.rawValue
            default:
                switchLabel.text = "Расписание"
            }
            
            labelContainer.addSubview(switchLabel)
            
            NSLayoutConstraint.activate([
                switchLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 16),
                switchLabel.centerYAnchor.constraint(equalTo: labelContainer.centerYAnchor),
            ])
            
            let scheduleSwitch = UISwitch()
            scheduleSwitch.isOn = false
            scheduleSwitch.isEnabled = true
            scheduleSwitch.onTintColor = .ypBlueIOS
            scheduleSwitch.tag = i
            scheduleSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            scheduleSwitch.translatesAutoresizingMaskIntoConstraints = false
            labelContainer.addSubview(scheduleSwitch)
            
            NSLayoutConstraint.activate([
                scheduleSwitch.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -16),
                scheduleSwitch.centerYAnchor.constraint(equalTo: labelContainer.centerYAnchor),
                scheduleSwitch.heightAnchor.constraint(equalToConstant: 31),
                scheduleSwitch.widthAnchor.constraint(equalToConstant: 51),
            ])
            
            switches.append(labelContainer)
        }
    }
    
    private func configureSwitchContainer() {
        stackView = UIStackView(arrangedSubviews: switches)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            stackView.heightAnchor.constraint(equalToConstant: 525),
            stackView.widthAnchor.constraint(equalToConstant: 343),
        ])
    }
    
    private func configureDoneButton() {
        doneButton = UIButton(type: .roundedRect)
        doneButton.backgroundColor = .ypBlackIOS
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 335),
        ])
    }
}

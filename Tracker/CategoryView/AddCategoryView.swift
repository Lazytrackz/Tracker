//
//  AddCategoryView.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 11.10.2026.
//

import UIKit

//MARK: - AddCategoryView

final class AddCategoryView: UIViewController {
    
    //MARK: - Delegate
    
    weak var delegate: AddCategoryViewDelegate?
    
    //MARK: - Private properties
    
    private var titleLabel = UILabel()
    private var doneButton = UIButton()
    private var categoryNameTextField = UITextField()
    private var categoryNameLabel = UILabel()
    private var isCategoryNameCreated = false
    private var trackerCategoryStore: TrackerCategoryStore?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //MARK: - Actions
    
    @objc private func didTapDoneButton() {
        trackerCategoryStore = TrackerCategoryStore()
        guard let categoryName = categoryNameTextField.text else { return }
        trackerCategoryStore?.addCategory(categoryName)
        delegate?.updateCategoryView()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private Methods
    
    private func configureView() {
        configureTitleLabel()
        configureCategoryNameLabel()
        configureDoneButton()
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        titleLabel.text = "Новая категория"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -678),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 120),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -119),
        ])
    }
    
    private func configureCategoryNameLabel() {
        categoryNameLabel.layer.cornerRadius = 16
        categoryNameLabel.layer.masksToBounds = true
        categoryNameLabel.backgroundColor = .ypBackgroundIOS
        categoryNameLabel.isUserInteractionEnabled = true
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryNameLabel)
        
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryNameLabel.heightAnchor.constraint(equalToConstant: 75),
            categoryNameLabel.widthAnchor.constraint(equalToConstant: 343),
        ])
        
        configureTextField()
    }
    
    
    private func configureTextField() {
        categoryNameTextField.placeholder = "Введите название категории"
        categoryNameTextField.isEnabled = true
        categoryNameTextField.isUserInteractionEnabled = true
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryNameTextField.resignFirstResponder()
        categoryNameTextField.delegate = self
        categoryNameLabel.addSubview(categoryNameTextField)
        
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: categoryNameLabel.topAnchor, constant: 27),
            categoryNameTextField.bottomAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: -26),
            categoryNameTextField.leadingAnchor.constraint(equalTo: categoryNameLabel.leadingAnchor, constant: 16),
        ])
    }
    
    private func configureDoneButton() {
        doneButton = UIButton(type: .roundedRect)
        doneButton.backgroundColor = .ypGrayIOS
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.titleLabel?.textColor = UIColor(resource: .ypWhiteIOS)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        checkDoneButtonStatus()
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 335),
        ])
    }
    
    private func checkDoneButtonStatus() {
        doneButton.backgroundColor = isCategoryNameCreated ? .ypBlackIOS : .ypGrayIOS
        doneButton.isEnabled = isCategoryNameCreated
    }
}

//MARK: - Extensions

extension AddCategoryView: UITextFieldDelegate {
    
    //MARK: - Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if !text.isEmpty {
            textField.resignFirstResponder()
            isCategoryNameCreated = true
            checkDoneButtonStatus()
            return true
        }else {
            return false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButton.isEnabled = true
    }
}

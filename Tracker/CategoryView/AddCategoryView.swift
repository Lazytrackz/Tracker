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
    private var addCategoryViewModel = AddCategoryViewModel()
    private var textFieldCharacterLimitLabel = UILabel()
    private var isNewCategory = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //MARK: - Actions
    
    @objc private func didTapDoneButton() {
        guard let categoryName = categoryNameTextField.text else { return }
        isNewCategory ? addCategoryViewModel.addCategory(categoryName) : addCategoryViewModel.rewriteExistingCategory(categoryName)
        delegate?.updateCategoryView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let characterLimit = 38
        if text.count > characterLimit{
            textField.text = String(text.prefix(characterLimit))
            textFieldCharacterLimitLabel.text = "Ограничение 38 символов"
        }else {
            textFieldCharacterLimitLabel.text = ""
        }
        text.isEmpty ? checkDoneButtonStatus(false) : checkDoneButtonStatus(true)
    }
    
    //MARK: - Methods
    
    func setLoadingViewStatus(isNewCategory: Bool) {
        self.isNewCategory = isNewCategory
    }
   
    //MARK: - Private Methods
    
    private func configureView() {
        self.view.backgroundColor = .ypWhiteIOS
        configureTitleLabel()
        configureCategoryNameLabel()
        configureCharacterLimitLabel()
        configureDoneButton()
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        isNewCategory ? (titleLabel.text = "Новая категория") : (titleLabel.text = "Редактирование категории")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 78),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -76),
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
        categoryNameTextField.clearButtonMode = .whileEditing
        categoryNameTextField.delegate = self
        categoryNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        !isNewCategory ? categoryNameTextField.text = addCategoryViewModel.getCategoryName() : nil
        categoryNameLabel.addSubview(categoryNameTextField)
        
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: categoryNameLabel.topAnchor, constant: 27),
            categoryNameTextField.bottomAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: -26),
            categoryNameTextField.leadingAnchor.constraint(equalTo: categoryNameLabel.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: categoryNameLabel.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCharacterLimitLabel() {
        textFieldCharacterLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldCharacterLimitLabel.textColor = UIColor(resource: .ypRedIOS)
        textFieldCharacterLimitLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textFieldCharacterLimitLabel.text = ""
        textFieldCharacterLimitLabel.textAlignment = .center
        view.addSubview(textFieldCharacterLimitLabel)
        
        NSLayoutConstraint.activate([
            textFieldCharacterLimitLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 8),
            textFieldCharacterLimitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            textFieldCharacterLimitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -29)
        ])
    }
    
    
    
    private func configureDoneButton() {
        doneButton = UIButton(type: .roundedRect)
        doneButton.backgroundColor = .ypGrayIOS
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhiteIOS, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.titleLabel?.textColor = UIColor(resource: .ypWhiteIOS)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        isNewCategory ? checkDoneButtonStatus(false) : checkDoneButtonStatus(true)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 335),
        ])
    }
    
    private func checkDoneButtonStatus(_ isCategoryNameCreated: Bool) {
        doneButton.backgroundColor = isCategoryNameCreated ? .ypBlackIOS : .ypGrayIOS
        doneButton.isEnabled = isCategoryNameCreated
    }
}

//MARK: - Extensions

extension AddCategoryView: UITextFieldDelegate {
    
    //MARK: - Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 11.10.2026.
//

import UIKit

//MARK: - CategoryViewController

final class CategoryViewController: UIViewController {
    
    //MARK: - Delegate
    
    weak var delegate: CategoryViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var tableView: UITableView = UITableView()
    private var titleLabel = UILabel()
    private var emptyTableLabel = UILabel()
    private var emptyTableIcon = UIImageView()
    private var addCategoryButton = UIButton()
    private var addCategoryView: AddCategoryView?
    private var categoryViewModel: CategoryViewModel?
    private var selectedItem: String?
    private var tableViewIsVisibility = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateData()
    }
    
    //MARK: - Actions
    
    @objc private func didTapAddButton() {
        addCategoryView = AddCategoryView()
        addCategoryView?.delegate = self
        guard let addCategoryView else { return }
        present(addCategoryView, animated: true)
    }
    
    //MARK: - Private methods
    
    private func configureView() {
        configureTitleLabel()
        configureEmptyTableIcon()
        configureEmptyTableLabel()
        configureAddCategoryButton()
        configureTableView()
    }
    
    private func updateData() {
        categoryViewModel = CategoryViewModel()
        categoryViewModel?.onTasksUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        categoryViewModel?.updateCategoriesTableView()
        guard let count = categoryViewModel?.getCategoriesCount() else { return }
        if count > 0 {
            tableViewIsVisibility = true
            changeTableViewVisibility()
        } else {
            tableViewIsVisibility = false
            changeTableViewVisibility()
        }
    }
    
    private func changeTableViewVisibility() {
        if tableViewIsVisibility {
            tableView.isHidden = false
            emptyTableIcon.isHidden = true
            emptyTableLabel.isHidden = true
        }else {
            tableView.isHidden = true
            emptyTableIcon.isHidden = false
            emptyTableLabel.isHidden = false
        }
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -47)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        titleLabel.text = "Категория"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 146),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -145),
        ])
    }
    
    private func configureEmptyTableLabel() {
        emptyTableLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyTableLabel.textColor = UIColor(resource: .ypBlackIOS)
        emptyTableLabel.textAlignment = .center
        emptyTableLabel.lineBreakMode = .byWordWrapping
        emptyTableLabel.numberOfLines = 2
        emptyTableLabel.adjustsFontSizeToFitWidth = false
        emptyTableLabel.text = LabelsText.categoryViewEmptyLabel
        emptyTableLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyTableLabel)
        
        NSLayoutConstraint.activate([
            emptyTableLabel.topAnchor.constraint(equalTo: emptyTableIcon.bottomAnchor, constant: 8),
            emptyTableLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyTableLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureEmptyTableIcon() {
        let image = UIImage(resource: .emptyTracker)
        emptyTableIcon = UIImageView(image: image)
        emptyTableIcon.contentMode = .scaleAspectFit
        emptyTableIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyTableIcon)
        
        NSLayoutConstraint.activate([
            emptyTableIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 306),
            emptyTableIcon.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 147),
            emptyTableIcon.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -148),
        ])
    }
    
    private func configureAddCategoryButton() {
        addCategoryButton = UIButton(type: .roundedRect)
        addCategoryButton.backgroundColor = .ypBlackIOS
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(.white, for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.titleLabel?.textColor = UIColor(resource: .ypWhiteIOS)
        addCategoryButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.layer.masksToBounds = true
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.widthAnchor.constraint(equalToConstant: 335),
        ])
    }
    
    private func configCell(for cell: CategoryCell, with indexPath: IndexPath){
        guard let categoryName = categoryViewModel?.getCategoriesName(at: indexPath.row) else { return }
        cell.delegate = self
        cell.setCategoryText(categoryName)
    }
}

//MARK: - Extensions

extension CategoryViewController: UITableViewDelegate {
    
    //MARK: - Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath, cell: CategoryCell) -> CGFloat {
        return 75
    }
}

extension CategoryViewController: UITableViewDataSource{
    
    //MARK: - Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = categoryViewModel?.getCategoriesCount() else { return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        guard let categoryCell = cell as? CategoryCell else {
            print("Failed to load cell")
            return UITableViewCell()
        }
        configCell(for: categoryCell, with: indexPath)
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = categoryViewModel?.getCategoriesName(at: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        guard let categoryCell = cell as? CategoryCell else { return }
        categoryCell.selectCell(true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let categoryCell = cell as? CategoryCell else { return }
        categoryCell.selectCell(false)
    }
}

extension CategoryViewController: AddCategoryViewDelegate {
    
    //MARK: - Methods
    
    func updateCategoryView() {
        updateData()
    }
}

extension CategoryViewController: CategoryCellDelegate {
    
    //MARK: - Methods
    
    func didCloseCategoryView() {
        guard let categoryName = selectedItem else { return }
        delegate?.setCategory(categoryName)
        self.dismiss(animated: true)
    }
}

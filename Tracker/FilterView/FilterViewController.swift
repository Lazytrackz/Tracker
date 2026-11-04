//
//  FilterViewController.swift
//  Tracker
//
//  Created by Aleksey Kosichenko on 27.10.2026.
//

import UIKit

//MARK: - TrackerCategoryStore

final class FilterViewController: UIViewController {
    
    //MARK: - Delegate
    
    weak var delegate: FilterViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var titleLabel = UILabel()
    private var tableView = UITableView()
    private var filterViewModel: FilterViewModel?
    private var selectedItem: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateData()
    }
    
    //MARK: - Private methods
    
    private func updateData() {
        filterViewModel = FilterViewModel()
        filterViewModel?.onTasksUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        filterViewModel?.updateFilterTableView()
    }
    
    private func configureView() {
        self.view.backgroundColor = .ypWhiteIOS
        configureTitleLabel()
        configureTableView()
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackIOS)
        titleLabel.text = "Фильтры"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 152),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -151),
        ])
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterCell.self, forCellReuseIdentifier: "filterCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -340)
        ])
    }
    
    private func configCell(for cell: FilterCell, with indexPath: IndexPath){
        guard let filterName = filterViewModel?.getFilterName(at: indexPath.row) else { return }
        //cell.delegate = self
        cell.setFilterText(filterName)
        let currentFilter = filterViewModel?.getCurrentFilter()
        if currentFilter == FilterType.completedTrackers.rawValue || currentFilter == FilterType.incompleteTrackers.rawValue {
            filterName == currentFilter ? cell.selectCell(true) : nil
        }
    }
    
    private func deselectCell(_ tableView: UITableView) {
        var indexPath: IndexPath?
        guard let index = filterViewModel?.checkSelectedCell() else { return }
        indexPath = IndexPath(item: index, section: 0)
        guard let indexPath else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterCell else { return }
        cell.selectCell(false)
    }
}

//MARK: - Extensions

extension FilterViewController: UITableViewDataSource {
    
    //MARK: - Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = filterViewModel?.getFilterCount() else { return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        guard let filterCell = cell as? FilterCell else {
            print("Failed to load cell")
            return UITableViewCell()
        }
        configCell(for: filterCell, with: indexPath)
        return filterCell
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = filterViewModel?.getFilterName(at: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        guard let filterCell = cell as? FilterCell else { return }
        deselectCell(tableView)
        filterCell.selectCell(true)
        guard let filterName = selectedItem else { return }
        filterViewModel?.setFilter(filterName)
        delegate?.updateFilter(filterName)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let filterCell = cell as? FilterCell else { return }
        filterCell.selectCell(false)
    }
}

/*extension FilterViewController: FilterCellDelegate {
    
    //MARK: - Methods
    
    func didCloseFilterView() {
        guard let filterName = selectedItem else { return }
        filterViewModel?.setFilter(filterName)
        delegate?.updateFilter(filterName)
        self.dismiss(animated: true)
    }
}*/

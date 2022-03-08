//
//  SearchCountryViewController.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import UIKit
import Combine

class SearchCountryViewController: BaseViewController {
    
    private let viewModel: SearchCountryViewModel
    private var disposeBag = Set<AnyCancellable>()
    
    private var tableView: UITableView!
    private let searchBar = UISearchBar()
    
    override init() {
        self.viewModel = SearchCountryViewModel()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBinds()
    }
}

extension SearchCountryViewController {
    private func setupView() {
        navigationItem.title = "Search Country"
        
        searchBar.placeholder = "Search"
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        tableView = UITableView.new {
            $0.rowHeight = 60
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.tableFooterView = UIView()
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
            $0.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseID)
            $0.dataSource = self
            $0.delegate = self
        }
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalTo(8)
            make.right.equalTo(-8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBinds() {
        viewModel.didSearchSubject
            .sink(receiveValue: { [weak self] _ in
                self?.view.stopActivityAnimating()
                self?.tableView.reloadData()
            }).store(in: &disposeBag)
    }
    
    private func onCountryPage(with country: Country) {
        let viewModel = CountryDetailsViewModel(with: country)
        let controller = CountryDetailsViewController(with: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchCountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trim.lowercased()
        view.startActivityAnimating()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchByName(with: searchText)
        }
    }
}

extension SearchCountryViewController: UITableViewDelegate,
                                 UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseID, for: indexPath) as? CountryCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.countries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onCountryPage(with: self.viewModel.countries[indexPath.row])
        }
    }
}

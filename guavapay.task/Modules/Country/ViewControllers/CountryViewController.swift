//
//  CountryViewController.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import UIKit
import SnapKit
import Combine

class CountriesViewController: BaseViewController {
    
    private let viewModel: CountryViewModel
    
    init(with viewModel: CountryViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

extension CountriesViewController {
    private func setupView() {
        navigationItem.title = "Countries"
        
        let tableView = UITableView.new {
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func onCountryPage(with country: Country) {
        let viewModel = CountryDetailsViewModel(with: country)
        let controller = CountryDetailsViewController(with: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CountriesViewController: UITableViewDelegate,
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


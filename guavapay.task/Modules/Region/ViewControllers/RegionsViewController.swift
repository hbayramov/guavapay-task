//
//  ViewController.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import UIKit
import SnapKit
import Combine

class RegionsViewController: BaseViewController {
    
    private let viewModel = RegionsViewModel()
    private let regions = Regions.allCases
    
    private var disposeBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBinds()
    }
}

extension RegionsViewController {
    private func setupView() {
        navigationItem.title = "Regions"
        
        let tableView = UITableView.new {
            $0.rowHeight = 45
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.tableFooterView = UIView()
            $0.register(RegionCell.self, forCellReuseIdentifier: RegionCell.reuseID)
            $0.dataSource = self
            $0.delegate = self
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinds() {
        viewModel.countriesSubject
            .sink(receiveCompletion: { [weak self] error in
                guard let self = self else { return }
                self.view.stopActivityAnimating()
                switch error {
                case .failure(let error):
                    Alerts.shared.showError(error.errorKey?.description ?? "",
                                            from: self)
                default: break
                }
            }, receiveValue: { [weak self] countries in
                self?.view.stopActivityAnimating()
                self?.onCountryPage(with: countries)
            }).store(in: &disposeBag)
    }
    
    private func onCountryPage(with countries: [Country]) {
        let viewModel = CountryViewModel(with: countries)
        let controller = CountriesViewController(with: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension RegionsViewController: UITableViewDelegate,
                                 UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        return regions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: RegionCell.reuseID, for: indexPath) as? RegionCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: regions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.startActivityAnimating()
            self.viewModel.fetchCountries(for: self.regions[indexPath.row])
        }
    }
}

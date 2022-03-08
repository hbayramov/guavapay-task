//
//  CountryDetailsViewController.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import UIKit
import SnapKit
import Combine
import MapKit

class CountryDetailsViewController: BaseViewController {
    
    private let viewModel: CountryDetailsViewModel
    private var disposeBag = Set<AnyCancellable>()
    
    private var tableView: UITableView!
    
    init(with viewModel: CountryDetailsViewModel) {
        self.viewModel = viewModel
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

extension CountryDetailsViewController {
    private func setupView() {
        navigationItem.title = viewModel.country.name?.common
        
        let flagLabel = UILabel.new {
            $0.textAlignment = .left
            $0.text = viewModel.country.flag
            $0.font = .systemFont(ofSize: 16, weight: .medium)
        }
        
        let currencyLabel = UILabel.new {
            $0.text = viewModel.country.currencies?.first?.value.name
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textAlignment = .left
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }
        
        let languageStackView = UIStackView.new {
            $0.axis = .vertical
            $0.spacing = 8
        }
        
        let languages = viewModel.country.languages?.map { return $0.value } ?? []
        languages.forEach { language in
            let languageLabel = UILabel.new {
                $0.text = language
                $0.font = .systemFont(ofSize: 16, weight: .medium)
                $0.textAlignment = .left
                $0.adjustsFontSizeToFitWidth = true
                $0.minimumScaleFactor = 0.8
            }
            languageStackView.addArrangedSubview(languageLabel)
        }
        
        let mapView = MKMapView.new {
            $0.setCenter(CLLocationCoordinate2D(latitude: Double(viewModel.country.latlng?[0] ?? 0),
                                                longitude: Double(viewModel.country.latlng?[1] ?? 0)),
                         animated: true)
        }
        
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
        
        view.addSubview(flagLabel)
        view.addSubview(currencyLabel)
        view.addSubview(languageStackView)
        view.addSubview(mapView)
        view.addSubview(tableView)
        
        flagLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(20)
        }
        
        currencyLabel.snp.makeConstraints { make in
            make.top.equalTo(flagLabel.snp.bottom).offset(16)
            make.leading.equalTo(20)
        }
        
        languageStackView.snp.makeConstraints { make in
            make.top.equalTo(currencyLabel.snp.bottom).offset(16)
            make.leading.equalTo(20)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(languageStackView.snp.bottom).offset(16)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBinds() {
        viewModel.neighborsDidFetch
            .sink(receiveValue: { [weak self] _ in
                self?.view.stopActivityAnimating()
                self?.tableView.reloadData()
            }).store(in: &disposeBag)
        
        self.view.startActivityAnimating()
        self.viewModel.fetchNeighbors()
    }
    
    private func onCountryPage(with country: Country) {
        let viewModel = CountryDetailsViewModel(with: country)
        let controller = CountryDetailsViewController(with: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CountryDetailsViewController: UITableViewDelegate,
                                        UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.neighbors.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseID, for: indexPath) as? CountryCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.neighbors[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onCountryPage(with: self.viewModel.neighbors[indexPath.row])
        }
    }
}

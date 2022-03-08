//
//  CountryDetailViewModel.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import Foundation
import Combine

final class CountryDetailsViewModel {
    private(set) var country: Country
    private(set) var neighbors: [Country] = []
    
    var neighborsDidFetch = PassthroughSubject<[Country], Never>()
    
    init(with country: Country) {
        self.country = country
    }
    
    func fetchNeighbors() {
        let api: CountryAPI = CountryAPI.countriesByCodes([
            "codes": country.borders?.joined(separator: ",") ?? ""
        ])
        let task = SharedNetworkManager.shared.sharedNetworkManager.dataTask(with: api) { [weak self] (result: Result<[Country], NetworkManager.GError>) in
            guard let self = self else {  return }
            
            switch result {
            case .success(let countries):
                self.neighbors = countries
                self.neighborsDidFetch.send(countries)
            default:
                self.neighborsDidFetch.send([])
            }
        }
        
        task.resume()
    }
}

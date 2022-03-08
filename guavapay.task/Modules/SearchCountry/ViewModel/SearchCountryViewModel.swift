//
//  SearchCountryViewModel.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import Foundation
import Combine

final class SearchCountryViewModel {
    
    private(set) var countries: [Country] = []
    var didSearchSubject = PassthroughSubject<[Country], Never>()
    
    func searchByName(with name: String) {
        let api: CountryAPI = CountryAPI.search(name)
        let task = SharedNetworkManager.shared.sharedNetworkManager.dataTask(with: api) { [weak self] (result: Result<[Country], NetworkManager.GError>) in
            guard let self = self else {  return }
            
            switch result {
            case .success(let countries):
                self.countries = countries
                self.didSearchSubject.send(countries)
            default:
                self.countries = []
                self.didSearchSubject.send([])
            }
        }
        
        task.resume()
    }
}

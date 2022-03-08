//
//  RegionsViewModel.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import Foundation
import Combine

final class RegionsViewModel {
    
    var countriesSubject = PassthroughSubject<[Country], NetworkManager.GError>()
    
    func fetchCountries(for region: Regions) {
        var api: CountryAPI = CountryAPI.countries(region.rawValue)
        
        switch region {
        case .australia:
            api = CountryAPI.subregion(region.rawValue)
        default: break
        }
        
        let task = SharedNetworkManager.shared.sharedNetworkManager.dataTask(with: api) { [weak self] (result: Result<[Country], NetworkManager.GError>) in
            guard let self = self else {  return }
            switch result {
            case .success(let countries):
                self.countriesSubject.send(countries)
            case .failure(let error):
                self.countriesSubject.send(completion: .failure(error))
            }
        }
        
        task.resume()
    }
}

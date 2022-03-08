//
//  CountryViewModel.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import Foundation

final class CountryViewModel {
    private(set) var countries: [Country]
    
    init(with countries: [Country]) {
        self.countries = countries
    }
}

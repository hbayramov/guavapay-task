//
//  Region.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import Foundation

enum Regions: String, Codable, CaseIterable {
    case asia = "Asia"
    case africa = "Africa"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case europe = "Europe"
    case australia = "Australia"
    
    var regionType: String {
        switch self {
        case .asia:
            return "region"
        case .africa:
            return "region"
        case .northAmerica:
            return "subregion"
        case .southAmerica:
            return "subregion"
        case .europe:
            return "region"
        case .australia:
            return "region"
        }
    }
}

//
//  Region.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import Foundation

enum Regions: CaseIterable {
    case asia
    case africa
    case northAmerica
    case southAmerica
    case antarctica
    case europe
    case australia
    
    var name: String {
        switch self {
        case .asia:
            return "Asia"
        case .africa:
            return "Africa"
        case .northAmerica:
            return "North America"
        case .southAmerica:
            return "South America"
        case .antarctica:
            return "Antarctica"
        case .europe:
            return "Europe"
        case .australia:
            return "Australia"
        }
    }
}

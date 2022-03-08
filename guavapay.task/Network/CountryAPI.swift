//
//  CountriesAPI.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import Foundation

enum CountryAPI: APIProtocol {
    case countries(String)
    case subregion(String)
    case search(String)
    case countriesByCodes([String: String])
    
    var method: HTTPMethod {
        switch self {
        case .countries,
                .subregion,
                .search,
                .countriesByCodes:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .countries(let name):
            return "/region/\(name)"
        case .subregion(let name):
            return "/subregion/\(name)"
        case .search(let name):
            return "/name/\(name)"
        case .countriesByCodes:
            return "/alpha"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .countries,
                .subregion,
                .search:
            return [:]
        case .countriesByCodes(let params):
            return params
        }
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var parameterType: ParameterType {
        switch self {
        case .countries,
                .subregion,
                .search,
                .countriesByCodes:
            return .query(.get)
        }
    }
    
    var isAuthNeeded: Bool {
        return false
    }
}

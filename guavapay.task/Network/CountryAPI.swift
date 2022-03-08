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
    case countriesByCodes([String: String])
    
    var method: HTTPMethod {
        switch self {
        case .countries,
                .subregion,
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
        case .countriesByCodes:
            return "/alpha"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .countries,
                .subregion:
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
                .countriesByCodes:
            return .query(.get)
        }
    }
    
    var isAuthNeeded: Bool {
        return false
    }
}

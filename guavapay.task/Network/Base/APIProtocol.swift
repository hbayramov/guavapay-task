//
//  APIProtocol.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum URLScheme: String {
    case http
    case https
}

enum ParameterType {
  case query(HTTPMethod)
  case body(HTTPMethod)
  case none
}

protocol APIProtocol {
    var method: HTTPMethod { get }
    var scheme: URLScheme { get }
    var host: String { get }
    var version: String { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
    var parameterType: ParameterType { get }
    var isAuthNeeded: Bool { get }
}

enum BaseUrl: String {
    case development = "https://restcountries.com"
    case production = "prod url"
}

extension APIProtocol {
    var method: HTTPMethod { return .get }
    var scheme: URLScheme { return .http }
    var host: String {
        #if DEBUG
        return BaseUrl.production.rawValue
        #else
        return BaseUrl.development.rawValue
        #endif
    }
    var version: String { return "/v3.1" }
    var parameters: [String: Any] { return [:] }
    var headers: [String: String] { return [:] }
    var isAuthNeeded: Bool { return true }
}

extension APIProtocol {
    func buildURLRequest() -> URLRequest {
        
        var components = URLComponents()
        components.scheme = self.scheme.rawValue
        components.host = self.host
        components.path = self.version + self.path
              
        switch self.parameterType {
        case .query(.get),
            .query(.post),
            .query(.delete):
          components.queryItems = self.parameters.map {
              return URLQueryItem(name: $0.key, value: String(describing: $0.value))
          }
        default:
          components.queryItems = nil
        }

        guard let url = components.url else {
            preconditionFailure("Invalid url components")
        }
      
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod = self.method.rawValue
        
        switch self.parameterType {
        case .body(.post):
            if let array = self.parameters["JSON_ARRAY"] {
                print(array)
                request.httpBody = try? JSONSerialization.data(withJSONObject: array)
            } else {
                request.httpBody = try? JSONSerialization.data(withJSONObject: self.parameters)
            }
            #if DEBUG
            let jsonStr = String(data: request.httpBody!, encoding: .utf8)!
            print("HTTP_BODY:: START:: json string::")
            print(jsonStr)
            print("HTTP_BODY:: END::")
            #endif
            components.queryItems = nil
        default:
          break
        }
        
        return request
    }
}


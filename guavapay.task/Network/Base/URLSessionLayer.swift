//
//  URLSessionLayer.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import Foundation

class URLSessionLayer {
    enum LayerError: Error {
        case missingHttpUrlResponse
        case missingData
    }
    
    struct Payload {
        struct SuccessModel {
            let data: Data
            let httpStatusCode: Int
        }
        
        let result: Result<SuccessModel, Error>
        let httpUrlResponse: HTTPURLResponse?
    }
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func dataTask(with request: URLRequest, completion: ((Payload) -> Void)?) -> URLSessionDataTask {
        let task = session.dataTask(
            with: request
        ) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            // Error -> system
            if let error = error {
                completion?(Payload(result: .failure(error), httpUrlResponse: urlResponse as? HTTPURLResponse))
                return
            }
            
            // Error -> nil response
            guard let response = urlResponse as? HTTPURLResponse else {
                let error = LayerError.missingHttpUrlResponse
                completion?(Payload(result: .failure(error), httpUrlResponse: nil))
                return
            }
            
            // Error -> nil data
            guard let data = data else {
                let error = LayerError.missingData
                completion?(Payload(result: .failure(error), httpUrlResponse: response))
                return
            }
            
            // Data
            completion?(Payload(
                result: .success(Payload.SuccessModel(data: data, httpStatusCode: response.statusCode)),
                httpUrlResponse: response
            ))
            return
        }
        return task
    }
}

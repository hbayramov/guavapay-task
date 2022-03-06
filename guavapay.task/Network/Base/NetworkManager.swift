//
//  NetworkManager.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import Foundation

protocol NetworkManagerDelegate: AnyObject {
    func networkInject(networkManager: NetworkManager, api: APIProtocol, request: URLRequest) -> URLRequest
    func networkManager(networkManager: NetworkManager, api: APIProtocol, error: NetworkManager.GError, httpURLResponse: HTTPURLResponse?)
}

class NetworkManager {
    private let session = URLSessionLayer()
    weak var nmDelegate: NetworkManagerDelegate?
    
    // @discardableResult
    func dataTask<T: Decodable>(
        with api: APIProtocol,
        completion: ((Result<T, GError>) -> Void)?
    ) -> URLSessionDataTask {
        let apiRequest = api.buildURLRequest()
        let request = nmDelegate?.networkInject(networkManager: self, api: api, request: apiRequest) ?? apiRequest
        let queue = DispatchQueue.main
        
        #if DEBUG
        print("NETWORK:: ┌─────── network REQUEST")
        print("NETWORK:: ├── action: \(request.url?.path ?? "")")
        print("NETWORK:: ├── method: \(request.httpMethod ?? "")")
        print("NETWORK:: ├── url: \(request)")
        print("NETWORK:: ├── headers:")
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            print("NETWORK:: ├───── \(key) = \(value)")
        }
        print("NETWORK:: ├── parameters:")
        if let data = request.httpBody {
            let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            for (key, value) in parameters ?? [:] {
                print("NETWORK:: ├───── \(key) = \(value)")
            }
        }
        print("NETWORK:: └──────────────────────────────────────────")
        #endif
        
        let task = session.dataTask(with: request) { [weak self] payload in
            guard let self = self else { return }
            
            #if DEBUG
            _ = {
                let httpURLResponse = payload.httpUrlResponse
                print("NETWORK:: ┌─────── network RESPONSE")
                print("NETWORK:: ├── response: \(httpURLResponse?.url?.absoluteString ?? "")")
                print("NETWORK:: ├── statusCode: \(httpURLResponse?.statusCode ?? 99_999)")
                print("NETWORK:: ├── data:")
                if let data = try? payload.result.get().data {
                    print("NETWORK:: ├───── \(String(data: data, encoding: .utf8)?.prefix(2_500) ?? "Wrong string")")
                }
            }()
            #endif
            
            switch payload.result {
            case .success(let successModel):
                switch successModel.httpStatusCode {
                case 200:
                    do {
                        // Success
                        let successObject = try JSONDecoder().decode(T.self, from: successModel.data)
                        queue.async {
                            completion?(.success(successObject))
                        }
                    } catch let catchError {
                      let error = GError(status: payload.httpUrlResponse?.statusCode ?? 0, errorKey: .unknown)
                        queue.async {
                          completion?(.failure(GError(status: payload.httpUrlResponse?.statusCode ?? 0, errorKey: .unknown)))
                            self.nmDelegate?.networkManager(
                                networkManager: self,
                                api: api,
                                error: error,
                                httpURLResponse: payload.httpUrlResponse
                            )
                        }
                        #if DEBUG
                        print("DECODE ERROR:: error: \(catchError)")
                        #endif
                    }
                default:
                    do {
                        // API error
                      let errorObject = try JSONDecoder().decode(GError.self, from: successModel.data)
                        queue.async {
                            completion?(.failure(errorObject))
                            self.nmDelegate?.networkManager(
                                networkManager: self,
                                api: api,
                                error: errorObject,
                                httpURLResponse: payload.httpUrlResponse
                            )
                        }
                        #if DEBUG
                        print("API ERROR:: error: \(errorObject)")
                        #endif
                    } catch let catchError {
                        let error = GError(status: payload.httpUrlResponse?.statusCode ?? 0,
                                                errorKey: .unknown)
                        queue.async {
                            completion?(.failure(error))
                            self.nmDelegate?.networkManager(
                                networkManager: self,
                                api: api,
                                error: error,
                                httpURLResponse: payload.httpUrlResponse
                            )
                        }
                        #if DEBUG
                        print("API ERROR -> DECODE ERROR:: error: \(catchError)")
                        #endif
                    }
                }
            case .failure:
                let error = GError(status: payload.httpUrlResponse?.statusCode ?? 0,
                                        errorKey: .unknown)
                queue.async {
                    completion?(.failure(error))
                    self.nmDelegate?.networkManager(
                        networkManager: self,
                        api: api,
                        error: error,
                        httpURLResponse: payload.httpUrlResponse
                    )
                }
                #if DEBUG
                print("NETWORK:: error: \(error)")
                #endif
            }
        }
        return task
    }
}

// MARK: - Errors

extension NetworkManager {
    struct GError: Error, Decodable {
        var status: Int?
        var message: String?
        var errorKey: NetworkError?
    }
}

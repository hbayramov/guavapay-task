//
//  SharedNetworkManager.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import Foundation

final class SharedNetworkManager {
    fileprivate let networkManager: NetworkManager
    
    static let shared = SharedNetworkManager()
    
    var sharedNetworkManager: NetworkManager {
        return networkManager
    }
    
    init() {
        let networkManager = NetworkManager()
        self.networkManager = networkManager
                
        networkManager.nmDelegate = self
    }
}

// MARK: - NetworkManagerDelegate
extension SharedNetworkManager: NetworkManagerDelegate {
    func networkInject(
        networkManager: NetworkManager,
        api: APIProtocol,
        request: URLRequest
    ) -> URLRequest {
        var request = request
        
        if api.isAuthNeeded {
            let token = "Bearer" + " "
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func networkManager(
        networkManager: NetworkManager,
        api: APIProtocol,
        error: NetworkManager.GError,
        httpURLResponse: HTTPURLResponse?
    ) {
        //
    }
}

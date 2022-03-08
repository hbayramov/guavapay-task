//
//  Alerts.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//
import UIKit

final class Alerts {
    private init() {}
    
    static let shared = Alerts()
    
    func showSuccess(_ message: String,
                     from viewController: UIViewController,
                     handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Success",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default, handler: { _ in handler() }))
        
        viewController.present(alert, animated: true)
    }
    
    func showWarning(_ message: String,
                     from viewController: UIViewController) {
        let alert = UIAlertController(title: "Warning",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default, handler: nil))
        
        viewController.present(alert, animated: true)
    }
    
    func showError(_ message: String,
                   from viewController: UIViewController) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .default, handler: nil))
        
        viewController.present(alert, animated: true)
    }
}

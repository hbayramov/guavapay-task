//
//  UIView+extension.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import UIKit

extension UIView {
    static var reuseID: String {
        return "\(self)ID"
    }
}


// MARK: ActivityIndicator
extension UIView {
    func startActivityAnimating() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = UIColor.white.alpha(0.5)
        activityIndicator.color = UIColor.init(hex: "#1DA1F2")
        activityIndicator.hidesWhenStopped = true
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        }
        
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        self.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func stopActivityAnimating() {
        let activityIndicator = subviews.compactMap { $0 as? UIActivityIndicatorView }.first
        activityIndicator?.removeFromSuperview()
        self.isUserInteractionEnabled = true
        activityIndicator?.stopAnimating()
    }
}

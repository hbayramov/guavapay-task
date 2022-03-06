//
//  UIColor+extension.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import UIKit.UIColor

extension UIColor {
    public convenience init(hex: String, alpha: CGFloat) {
        let value: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let hex = value.hasPrefix("#") ? hex.replacingOccurrences(of: "#", with: "") : value
        var rgbValue: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat((rgbValue & 0x0000FF)) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}

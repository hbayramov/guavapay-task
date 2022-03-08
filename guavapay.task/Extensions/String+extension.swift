//
//  String+extension.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import Foundation

extension String {
    var trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

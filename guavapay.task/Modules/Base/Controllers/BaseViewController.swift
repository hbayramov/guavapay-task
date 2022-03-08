//
//  BaseViewController.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import UIKit

class BaseViewController: UIViewController {
            
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Setup View
extension BaseViewController {
    private func setupBase() {
        view.backgroundColor = UIColor.init(hex: "#FBFBFB")
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
}


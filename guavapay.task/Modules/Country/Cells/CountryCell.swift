//
//  CountryCell.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import UIKit
import SnapKit

final class CountryCell: UITableViewCell {
    
    let flagLabel = UILabel.new {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    let latinNameLabel = UILabel.new {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.8
    }
    
    let nativeNameLabel = UILabel.new {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.8
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        
        contentView.addSubview(flagLabel)
        contentView.addSubview(latinNameLabel)
        contentView.addSubview(nativeNameLabel)
        
        flagLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(20)
        }
        
        latinNameLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(flagLabel.snp.trailing).offset(8)
            make.trailing.equalTo(-8)
        }
        
        nativeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(latinNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(latinNameLabel.snp.leading)
            make.trailing.equalTo(-8)
        }
    }
    
    func configure(with country: Country) {
        flagLabel.text = country.flag
        latinNameLabel.text = country.name?.common
        nativeNameLabel.text = country.name?.nativeName?.first?.value.official
    }
}

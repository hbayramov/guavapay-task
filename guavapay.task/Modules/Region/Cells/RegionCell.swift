//
//  RegionCell.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 08.03.22.
//

import UIKit
import SnapKit

final class RegionCell: UITableViewCell {
    
    let titleLabel = UILabel.new {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .lightGray
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
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
    }
    
    func configure(with region: Regions) {
        titleLabel.text = region.rawValue
    }
}

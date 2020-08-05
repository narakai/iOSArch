//
// Created by apple on 2020/7/24.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit
import SnapKit

class BasicInfoTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = createLabel(font: .title)
    lazy var descLabel: UILabel = createLabel(font: .subTitle)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.numberOfLines = 1
        descLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        layoutIfNeeded()
    }
}

extension BasicInfoTableViewCell {
    private func createLabel(font: UIFont = UIFont.small) -> UILabel {
        let label = UILabel()
        label.font = font
        return label
    }
}

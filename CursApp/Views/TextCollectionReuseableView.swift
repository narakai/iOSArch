//
//  TextCollectionReuseableView.swift

//
//  Created by lailiang on 2020/3/13.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextCollectionReuseableView: UICollectionReusableView {
    let disposeBag = DisposeBag()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .largeTitle
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        appTheme.rx
                .bind({ $0.textColor }, to: textLabel.rx.textColor)
                .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
    }
}

//
// Created by lailiang on 2020/7/21.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit
import CRBoxInputView

class CodeEntryViewController: BaseViewController {

    @IBOutlet weak var tipTX: UILabel!
    
    @IBOutlet weak var codeInputView: CRBoxInputView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var retryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeInputView.loadAndPrepare()
        codeInputView.mainCollectionView()?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        codeInputView.resetCodeLength(6, beginEdit: true)
        self.confirmBtn.isUserInteractionEnabled = false
//        self.confirmBtn.isSelected = false
        codeInputView.textDidChangeblock = {(text: String?, isFinished: Bool) in
            if (isFinished) {
                self.confirmBtn.isUserInteractionEnabled = true
//                self.confirmBtn.isSelected = true
                self.confirmBtn.setTitleColor(UIColor.fromHex(0x52b6f4), for: .normal)
            }
        };
    }

    override func bindViewsTheme() {
        super.bindViewsTheme()
        appTheme.rx
                .bind({ $0.lightBackgroundColor }, to: confirmBtn.rx.backgroundColor)
                .bind({ $0.textColor }, to: tipTX.rx.textColor)
                .bind({ $0.primaryColor }, to: retryBtn.rx.titleColor(for: .normal))
//                .bind({ $0.primaryColor }, to: confirmBtn.rx.titleColor(for: .selected), retryBtn.rx.titleColor(for: .normal))
//                .bind({ $0.subTextColor }, to: confirmBtn.rx.titleColor(for: .normal))
                .disposed(by: disposeBag)
    }

    override func bindNavigationBarTheme() {
        if let nav = navigationController {
            nav.navigationBar.shadowImage = UIImage()
            appTheme.rx
                    .bind({ $0.backgroundColor }, to: nav.navigationBar.rx.barBackgroundColor)
                    .bind({ $0.textColor }, to: nav.navigationBar.rx.tintColor)
                    .disposed(by: disposeBag)
        }
    }
}

//
// Created by lailiang on 2020/7/20.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

class GetPasswordViewController: BaseViewController {
    @IBOutlet weak var messageTX: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!

    @IBOutlet weak var mailContainer: UIView!
    
    @IBOutlet weak var mailTF: UITextField!

    let viewModel = GetPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        mailTF.attributedPlaceholder = NSAttributedString.init(string: "请输入邮箱", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray])

        viewModel.loading.asObservable().bind(to: showLoading).disposed(by: disposeBag)
        viewModel.error.asObservable().bind(to: showError).disposed(by: disposeBag)

        let mail = mailTF.rx.text.filterNil()

        let input = GetPasswordViewModel.Input(
                mail: mail,
                sendMail: nextBtn.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.validate.subscribe(onNext: { [weak self] validate in
                    guard let `self` = self else {
                        return
                    }
                    self.nextBtn.isUserInteractionEnabled = validate
                    self.nextBtn.isSelected = validate
                })
                .disposed(by: disposeBag)

        output.sendMailSuccess.subscribe(onNext: { [weak self] success in
                    if (success) {
                        self?.dismiss(animated: true)
                        Toast(text: "密码已成功发送至指定邮箱", duration: Delay.short).show()
                    }
                })
                .disposed(by: disposeBag)
    }

    override func bindViewsTheme() {
        super.bindViewsTheme()
        appTheme.rx
                .bind({ $0.lightBackgroundColor }, to: mailContainer.rx.backgroundColor, nextBtn.rx.backgroundColor)
                .bind({ $0.textColor }, to: mailTF.rx.textColor, messageTX.rx.textColor)
                .bind({ $0.primaryColor }, to: nextBtn.rx.titleColor(for: .selected))
                .bind({ $0.subTextColor }, to: nextBtn.rx.titleColor(for: .normal))
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

extension GetPasswordViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

//
// Created by lailiang on 2020/7/20.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneLoginViewController: BaseViewController {
    @IBOutlet weak var codeTX: UILabel!
    @IBOutlet weak var welcomeTX: UILabel!

    @IBOutlet weak var getCodeBtn: UIButton!

    @IBOutlet weak var switchLoginBtn: UIButton!

    @IBOutlet weak var phoneTFContainer: UIView!

    @IBOutlet weak var phoneTF: UITextField!

    let viewModel = PhoneLoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTF.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray])

        viewModel.loading.asObservable().bind(to: showLoading).disposed(by: disposeBag)
        viewModel.error.asObservable().bind(to: showError).disposed(by: disposeBag)

        let phoneNumber = phoneTF.rx.text.filterNil()

        let input = PhoneLoginViewModel.Input(
                phoneNumber: phoneNumber,
                getCode: getCodeBtn.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.validate.subscribe(onNext: { [weak self] validate in
                    guard let `self` = self else {
                        return
                    }
                    self.getCodeBtn.isUserInteractionEnabled = validate
                    self.getCodeBtn.isSelected = validate
                })
                .disposed(by: disposeBag)

        output.getCodeSuccess.subscribe(onNext: { [weak self] success in
                    if (success) {
                        if let codeEntryVC = CodeEntryViewController.fromStoryboard() {
                            self?.navigationController?.pushViewController(codeEntryVC, animated: true)
                        }
                    }
                })
                .disposed(by: disposeBag)

        switchLoginBtn.rx.tap.subscribe(onNext: { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
    }

    override func bindViewsTheme() {
        super.bindViewsTheme()
        appTheme.rx
                .bind({ $0.lightBackgroundColor }, to: phoneTFContainer.rx.backgroundColor, getCodeBtn.rx.backgroundColor)
                .bind({ $0.textColor }, to: phoneTF.rx.textColor, codeTX.rx.textColor, welcomeTX.rx.textColor)
                .bind({ $0.primaryColor }, to: getCodeBtn.rx.titleColor(for: .selected), switchLoginBtn.rx.titleColor(for: .normal))
                .bind({ $0.subTextColor }, to: getCodeBtn.rx.titleColor(for: .normal))
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

extension PhoneLoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

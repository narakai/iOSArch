//
// Created by lailiang on 2020/7/20.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var messageTX: UILabel!

    @IBOutlet weak var confirmBtn: UIButton!

    @IBOutlet weak var oldPasswordContainer: UIView!

    @IBOutlet weak var newPasswordContainer: UIView!

    @IBOutlet weak var newPasswordContainer2: UIView!

    @IBOutlet weak var oldPasswordTF: UITextField!

    @IBOutlet weak var newPasswordTF: UITextField!

    @IBOutlet weak var newPasswordTF2: UITextField!

    let viewModel = ChangePasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        oldPasswordTF.attributedPlaceholder = NSAttributedString.init(string: "请输入旧密码", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray])

        newPasswordTF.attributedPlaceholder = NSAttributedString.init(string: "请输入新密码", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray])

        newPasswordTF2.attributedPlaceholder = NSAttributedString.init(string: "请再次输入新密码", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray])

        viewModel.loading.asObservable().bind(to: showLoading).disposed(by: disposeBag)
        viewModel.error.asObservable().bind(to: showError).disposed(by: disposeBag)

        let oldPW = oldPasswordTF.rx.text.filterNil()
        let newPW = newPasswordTF.rx.text.filterNil()
        let newPWRe = newPasswordTF2.rx.text.filterNil()

        let input = ChangePasswordViewModel.Input(
                oldPW: oldPW,
                newPW: newPW,
                newPWRe: newPWRe,
                sendNewPW: confirmBtn.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)
        output.validate.subscribe(onNext: { [weak self] validate in
                    guard let `self` = self else {
                        return
                    }
                    self.confirmBtn.isUserInteractionEnabled = validate
                    self.confirmBtn.isSelected = validate
                })
                .disposed(by: disposeBag)

        output.sendNewPWSuccess.subscribe(onNext: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                    Toast(text: "密码修改成功", duration: Delay.short).show()
                })
                .disposed(by: disposeBag)
    }

    override func bindViewsTheme() {
        super.bindViewsTheme()
        appTheme.rx
                .bind({ $0.lightBackgroundColor }, to: oldPasswordContainer.rx.backgroundColor, newPasswordContainer.rx.backgroundColor, newPasswordContainer2.rx.backgroundColor, confirmBtn.rx.backgroundColor)
                .bind({ $0.textColor }, to: oldPasswordTF.rx.textColor, newPasswordTF.rx.textColor, newPasswordTF2.rx.textColor, messageTX.rx.textColor)
                .bind({ $0.primaryColor }, to: confirmBtn.rx.titleColor(for: .selected))
                .bind({ $0.subTextColor }, to: confirmBtn.rx.titleColor(for: .normal))
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

extension ChangePasswordViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

//
// Created by lailiang on 2020/7/22.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChangePasswordViewModel: ViewModel, ViewModelType {

    struct Input {
        let oldPW: Observable<String>
        let newPW: Observable<String>
        let newPWRe: Observable<String>
        let sendNewPW: Observable<Void>
    }

    struct Output {
        let validate: Observable<Bool>
        let sendNewPWSuccess: Observable<Void>
    }

    let oldPW = BehaviorRelay<String>(value: "")
    let newPW = BehaviorRelay<String>(value: "")
    let newPWRe = BehaviorRelay<String>(value: "")

    func transform(input: Input) -> Output {
        let validate = Observable
                .combineLatest(input.oldPW, input.newPW, input.newPWRe)
                .map {
                    !$0.isEmpty && !$1.isEmpty && !$2.isEmpty
                            && $0.count > 5 && $1.count > 5
                            && $1 == $2
                }

        input.oldPW.bind(to: oldPW).disposed(by: disposeBag)
        input.newPW.bind(to: newPW).disposed(by: disposeBag)
        input.newPWRe.bind(to: newPWRe).disposed(by: disposeBag)

        let request = input.sendNewPW.flatMapLatest { [weak self] _ -> Observable<Void> in
            guard let `self` = self else {
                return Observable.empty()
            }
            let loginInfo = LoginResponseInfo.fromLocal()
            let userInfoBean = UserInfoBean.fromLocal()
            if (loginInfo == nil || loginInfo!.payload == "" || userInfoBean == nil) {
                return Observable.empty()
            }

            let oldPW = self.oldPW.value
            let newPW = self.newPW.value

            userInfoBean!.oldPassword = oldPW
            userInfoBean!.password = newPW

            #if DEBUG
            print(loginInfo!.payload + " " + oldPW + " " + newPW)
            print(userInfoBean!.toJSON()!)
            #endif

            return UserAPI.provider.rx
                    .request(.changePW(loginInfo!.payload, userInfoBean!))
                    .validateSuccess()
                    .trackErrorJustComplete(self.error)
                    //                            .trackErrorJustReturn(self.error, value: UserModel.getDummyUserForTest())
                    .trackActivity(self.loading)
        }

        return Output(
                validate: validate,
                sendNewPWSuccess: request
        )
    }
}
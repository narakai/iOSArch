//
// Created by lailiang on 2020/7/20.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneLoginViewModel: ViewModel, ViewModelType {

    struct Input {
        let phoneNumber: Observable<String>
        let getCode: Observable<Void>
    }

    struct Output {
        let validate: Observable<Bool>
        let getCodeSuccess: Observable<Bool>
    }

    let phoneNumber = BehaviorRelay<String>(value: "")

    func transform(input: Input) -> Output {
        let validate = input.phoneNumber
                .map { !$0.isEmpty && $0.count == 11 }

        input.phoneNumber.bind(to: phoneNumber).disposed(by: disposeBag)

        let request = input.getCode.flatMapLatest { [weak self] _ -> Observable<UserInfoBean> in
                    guard let `self` = self else { return Observable.empty() }
                    let phoneNumber = self.phoneNumber.value

                    return UserAPI.provider.rx
                            .request(.getCode(phoneNumber))
                            .mapModel(UserInfoBean.self, path: "data")
                            .trackErrorJustComplete(self.error)
//                            .trackErrorJustReturn(self.error, value: UserModel.getDummyUserForTest())
                            .trackActivity(self.loading)
                }
                .share(replay: 1)
                .do(onNext: { user in
                    user.writeToLocal()
                })

        request.bind(to: AppState.share.loginUser).disposed(by: disposeBag)
        let success = request.map { $0.isLogin }

        return Output(
                validate: validate,
                getCodeSuccess: success
        )
    }
}
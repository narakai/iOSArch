//
//  LoginViewModel.swift

//
//  Created by lailiang on 2020/4/2.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModel, ViewModelType {

    struct Input {
        let userName: Observable<String>
        let password: Observable<String>
        let login: Observable<Void>
    }

    struct Output {
        let validate: Observable<Bool>
        let userInfo: Observable<UserInfoBean>
    }

    let userName = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")

    func transform(input: Input) -> Output {
        let validate = Observable
                .combineLatest(input.userName, input.password)
                .map {
                    !$0.isEmpty && !$1.isEmpty && $1.count > 5 && $0.count > 5
                }

        input.userName.bind(to: userName).disposed(by: disposeBag)
        input.password.bind(to: password).disposed(by: disposeBag)

        let request = input.login.flatMapLatest { [weak self] _ -> Observable<UserInfoBean> in
            guard let `self` = self else {
                return Observable.empty()
            }

            let userName = self.userName.value
            let pwd = self.password.value

            let loginRequest = LoginRequest()
            loginRequest.userId = userName
            loginRequest.password = pwd
            loginRequest.service = ""
            loginRequest.jwt = ""

            return self.fetchPayload(loginRequest: loginRequest).flatMapLatest { [weak self] (info) -> Observable<UserInfoBean> in
                guard let `self` = self else {
                    return Observable.just(UserInfoBean())
                }
                return self.fetchUserInfo(payload: info.payload, userName: userName)
                        .trackErrorJustReturn(self.error, value: UserInfoBean())
                        .trackActivity(self.loading)
            }
        }

        request.bind(to: AppState.share.loginUser).disposed(by: disposeBag)

        let userInfoBean = request
                .map {
            $0
        }

        return Output(
                validate: validate,
                userInfo: userInfoBean
        )
    }

    func fetchPayload(loginRequest: LoginRequest) -> Observable<LoginResponseInfo> {
        UserAPI.provider.rx
                .request(.login(loginRequest))
                .mapModel(LoginResponseInfo.self)
                .trackErrorJustComplete(self.error)
                .share(replay: 1)
                .do(onNext: { payload in
                    payload.writeToLocal()
                })
    }

    func fetchUserInfo(payload: String, userName: String) -> Observable<UserInfoBean> {
        UserAPI.provider.rx
                .request(.user(payload, userName))
                .mapModel(UserInfoBean.self, path: "payload")
                .trackErrorJustReturn(self.error, value: UserInfoBean())
                .share(replay: 1)
                .do(onNext: { user in
                    user.writeToLocal()
                })
    }
}

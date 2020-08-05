//
//  RegisterViewModel.swift
//  CursApp
//
//  Created by lailiang on 2020/4/7.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: ViewModel, ViewModelType {
    struct Input {
        let userName: Observable<String>
        let password: Observable<String>
        let repPassword: Observable<String>
        let register: Observable<Void>
    }
    struct Output {
        let validate: Observable<Bool>
        let registerSuccess: Observable<Bool>
    }
    
    private let userName = BehaviorRelay<String>(value: "")
    private let password = BehaviorRelay<String>(value: "")
    private let repPassword = BehaviorRelay<String>(value: "")
    
    func transform(input: Input) -> Output {
        
        let validate = Observable
            .combineLatest(input.userName, input.password, input.repPassword)
            .map { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty
                    && $0.count > 5 && $1.count > 5 && $1 == $2}
        
        input.userName.bind(to: userName).disposed(by: disposeBag)
        input.password.bind(to: password).disposed(by: disposeBag)
        input.repPassword.bind(to: repPassword).disposed(by: disposeBag)
        
        let request = input.register.flatMapLatest { [weak self] (_) -> Observable<UserInfoBean> in
            guard let `self` = self else { return Observable.empty() }
            let userName = self.userName.value
            let pwd = self.password.value
            let repPwd = self.repPassword.value
            return UserAPI.provider.rx
                .request(.register(userName, pwd, repPwd))
                .mapModel(UserInfoBean.self, path: "data")
                .trackErrorJustComplete(self.error)
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
            registerSuccess: success
        )
    }
}

//
//  SettingsViewModel.swift
//  CursApp
//
//  Created by lailiang on 2020/4/8.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsViewModel: ViewModel, ViewModelType {
    struct Input {
        let switchTheme: Observable<Bool>
        var logout: Observable<Void>?
    }
    struct Output {
        var logoutSuccess: Observable<Void>?
    }
    
    func transform(input: Input) -> Output {
        input.switchTheme
            .map { $0 ? ThemeType.dark : .light }
            .bind(to: appTheme.switcher)
            .disposed(by: disposeBag)
        
        var logoutSuccess: Observable<Void>?

        let logoutRequest = LogoutRequest()
        logoutRequest.userId = AppState.share.loginUser.value.userName
        logoutRequest.clientIp = ""

        if let logout = input.logout {
            logoutSuccess = logout.flatMapLatest { (_) -> Observable<Void> in
                return UserAPI.provider.rx
                    .request(.logout(logoutRequest))
                    .validateSuccess()
                        .trackErrorJustReturn(self.error, value: ())
//                    .trackErrorJustComplete(self.error)
                    .trackActivity(self.loading)
            }
            .do(onNext: {
                let emptyUser = UserInfoBean()
                emptyUser.writeToLocal()
                let payload = LoginResponseInfo()
                payload.writeToLocal()
                AppState.share.loginUser.accept(emptyUser)
            })
        }
        
        return Output(
            logoutSuccess: logoutSuccess
        )
    }
}

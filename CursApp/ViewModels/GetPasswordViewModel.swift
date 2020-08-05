//
// Created by lailiang on 2020/7/22.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GetPasswordViewModel: ViewModel, ViewModelType {

    struct Input {
        let mail: Observable<String>
        let sendMail: Observable<Void>
    }

    struct Output {
        let validate: Observable<Bool>
        let sendMailSuccess: Observable<Bool>
    }

    let mail = BehaviorRelay<String>(value: "")

    func transform(input: Input) -> Output {
        let validate = input.mail
                .map { !$0.isEmpty && $0.contains("@") && $0.contains(".") 
        && $0.split(separator: ".").capacity > 1 && $0.split(separator: ".")[1].count > 1}

        input.mail.bind(to: mail).disposed(by: disposeBag)

        let request = input.sendMail.flatMapLatest { [weak self] _ -> Observable<SendMailResponseInfo> in
                    guard let `self` = self else { return Observable.empty() }
                    let mail = self.mail.value

                    return UserAPI.provider.rx
                            .request(.forgetPW(mail))
                            .mapModel(SendMailResponseInfo.self)
                            .trackErrorJustComplete(self.error)
                            //                            .trackErrorJustReturn(self.error, value: UserModel.getDummyUserForTest())
                            .trackActivity(self.loading)
                }

        let success = request.map { $0.payload }

        return Output(
                validate: validate,
                sendMailSuccess: success
        )
    }
}

//
//  AppState.swift

//
//  Created by lailiang on 2020/4/3.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AppState {
    static let share = AppState()
    
    let loginUser = BehaviorRelay<UserInfoBean>(value: UserInfoBean())
}

extension AppState {
    func setup() {
        DispatchQueue.main.async {
            if let user = UserInfoBean.fromLocal() {
                self.loginUser.accept(user)
            }
        }
    }
}

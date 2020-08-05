//
//  UserModel.swift
//  CursApp
//
//  Created by lailiang on 2020/4/2.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import HandyJSON

class BaseResponse: HandyJSON {
    var errorCode: String?;
    var globalMessage: String?;

    required init() {
    }
}

class LoginRequest: HandyJSON {
    var userId: String?;
    var password: String?;
    var service: String?;
    var jwt: String?;

    required init() {
    }
}

class LogoutRequest: HandyJSON {
    var userId: String?;
    var clientIp: String?;

    required init() {
    }
}

class LoginResponseInfo: BaseResponse {
    var payload: String = "";

    required init() {
    }
}

class SendMailResponseInfo: BaseResponse {
    var payload: Bool = false;

    required init() {
    }
}

class UserResponseInfo: BaseResponse {
    var payload: UserInfoBean?;

    required init() {
    }
}

class UserInfoBean: HandyJSON {
    var userName: String?;
    var gender: String?;
    var birthday: String?;
    var postalCode: String?;
    var telNumber: String?;
    var mobile: String?;
    var address: String?;
    var description: String?;
    var copyFrom: String?;
    var createBy: String?;
    var createdDate: String?;
    var defaultPassword: String?;
    var defaultPlatformName: String?;
    var department: String?;
    var email: String?;
    var enableDate: String?;
    var id: String?;
    var lastLoginDate: String?;
    var lastModifiedBy: String?;
    var lastModifiedDate: String?;
    var needChangePswComments: String?;
    var needChangePsw: String?;
    var oldPassword: String?;
    var orgCode: String?;
    var orgCodeInput: String?;
    var orgName: String?;
    var organizationId: String?;
    var password: String?;
    var position: String?;
    var rootOrgainzationCode: String?;
    var sendAlert: String?;
    var staffID: String?;
    var status: String?;
    var terminateDate: String?;
    var userId: String?;
    var userPic: String?;

    required init() {
    }
}

extension UserInfoBean {
    var isLogin: Bool {
        return id != nil && userName != nil && userId != nil
    }
}

extension UserInfoBean {
    class var cachePath: String {
        return "/user/loginInfo"
    }

//    class func getDummyUserForTest() -> UserModel {
//        let dummyUser = UserModel()
//        dummyUser.id = 10086
//        dummyUser.nickname = "西南凯亚"
//        dummyUser.department = "ACCA"
//        return dummyUser
//    }

    func writeToLocal() {
        guard
                let json = toJSONString(),
                let data = json.data(using: .utf8)
                else {
            return
        }
        FileUtils.write(data: data, to: UserInfoBean.cachePath)
    }

    class func fromLocal() -> UserInfoBean? {
        if let data = FileUtils.readData(from: UserInfoBean.cachePath) {
            let dataStr = String(data: data, encoding: .utf8)
            let user = UserInfoBean.deserialize(from: dataStr)
            return user
        }
        return nil
    }
}

extension LoginResponseInfo {
    class var cachePath: String {
        return "/user/payload"
    }

    func writeToLocal() {
        guard
                let json = toJSONString(),
                let data = json.data(using: .utf8)
                else {
            return
        }
        FileUtils.write(data: data, to: LoginResponseInfo.cachePath)
    }

    class func fromLocal() -> LoginResponseInfo? {
        if let data = FileUtils.readData(from: LoginResponseInfo.cachePath) {
            let dataStr = String(data: data, encoding: .utf8)
            let loginInfo = LoginResponseInfo.deserialize(from: dataStr)
            return loginInfo
        }
        return nil
    }
}

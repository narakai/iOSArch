//
//  UserAPI.swift
//  CursApp
//
//  Created by lailiang on 2020/3/17.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import Moya

enum UserAPI {
    case login(LoginRequest)
    case logout(LogoutRequest)
    case user(String, String)
    case register(String, String, String)
    case changePW(String, UserInfoBean)
    case forgetPW(String)
    case getCode(String)
}

extension UserAPI: TargetType {
    var path: String {
        switch self {
        case .getCode(_):
            return "user/getCode"
        case .login(_):
            return "login"
        case .user(_, _):
            return "user"
        case .register(_, _, _):
            return "user/register"
        case .logout(_):
            return "user/logout"
        case .changePW(_,_):
            return "user/changepassword"
        case .forgetPW(let userId):
            return "forgetpsw/" + userId + "/send"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login(_), .logout(_), .changePW(_, _), .forgetPW(_), .register(_, _, _):
            return .post
        default:
            return .get
        }
    }
    public var headers: [String: String]? {
        switch self {
        case .user(let payload, _):
            return ["jwt": payload];
        case .changePW(let payload, _):
            return ["jwt": payload];
        default:
            return .none
        }
    }

    var task: Task {
        switch self {
        case .user(_, let userName):
            return .requestParameters(parameters: ["userId": userName], encoding: URLEncoding.default)
        case .login(let loginRequest):
            return .requestParameters(
                    parameters: loginRequest.toJSON()!, encoding: JSONEncoding.default
            )
        case .logout(let logoutRequest):
            return .requestParameters(
                    parameters: logoutRequest.toJSON()!, encoding: JSONEncoding.default
            )
        case .changePW(_, let userInfoBean):
            return .requestParameters(
                    parameters: userInfoBean.toJSON()!, encoding: JSONEncoding.default
            )
        case .register(let userName, let pwd, let rePwd):
            return .requestParameters(
                    parameters: ["username": userName, "password": pwd, "repassword": rePwd],
                    encoding: URLEncoding.default
            )
        default:
            return .requestPlain
        }
    }

}

extension UserAPI {
    static let provider = MoyaProvider<UserAPI>(plugins: defaultPlugins)
}

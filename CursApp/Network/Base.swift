//
//  Base.swift

//
//  Created by lailiang on 2020/3/17.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    var baseURL: URL {
        return URL(string: "http://192.168.0.1:3000")!
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}

let defaultPlugins = { () -> [PluginType] in
    #if DEBUG
    return [NetworkLogger()]
    #else
    return []
    #endif
}()

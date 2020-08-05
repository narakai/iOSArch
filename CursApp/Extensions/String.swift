//
//  String.swift
//  CursApp
//
//  Created by lailiang on 2020/7/17.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation

extension String {
    var filterHTMLString: String {
        var result = self
        if let regExp = try? NSRegularExpression(pattern: "<[^>]*>|\\r|\\n", options: .caseInsensitive) {
            result = regExp.stringByReplacingMatches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count), withTemplate: "")
        }
        return result
    }
}

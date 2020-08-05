//
//  UIViewController.swift
//  CursApp
//
//  Created by lailiang on 2020/3/30.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit

extension UIViewController {
    class func fromStoryboard(
        name: String? = nil,
        identifier: String? = nil
    ) -> Self? {
        let selfName = String(describing: self)
        let storyboard = UIStoryboard(name: name ?? selfName,  bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier ?? selfName)
        return viewController as? Self
    }
}

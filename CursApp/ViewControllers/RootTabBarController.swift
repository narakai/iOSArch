//
//  RootViewController.swift
//  CursApp
//
//  Created by lailiang on 2020/7/15.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme

extension Reactive where Base: UITabBar {
    var barBackgroundColor: Binder<UIColor?> {
        return Binder<UIColor?>(self.base) { (bar, color) in
            let bgColor = color ?? .white
            let bgImage = bgColor.mapImage
            bar.backgroundImage = bgImage
        }
    }
}

class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllersConfig()
    }
    
}

extension RootTabBarController {
    private struct Item {
        let title: String
        let icon: Iconfont
        let vc: UIViewController
    }
    
    private func initViewControllersConfig() {
        let items = [
            Item(title: "首页", icon: Iconfont.home, vc: MineViewController()),
            Item(title: "体系", icon: Iconfont.tree, vc: MineViewController()),
            Item(title: "项目", icon: Iconfont.project, vc: MineViewController()),
            Item(title: "我的", icon: Iconfont.user, vc: MineViewController()),
        ]
        
        viewControllers = items.map { item in
            item.vc.tabBarItem.title = item.title
            item.vc.tabBarItem.image = item.icon.image(size: 24)
            let nav = UINavigationController(rootViewController: item.vc)
            return nav
        }
        
        appTheme.rx.bind({ $0.primaryColor }, to: tabBar.rx.tintColor)
        appTheme.rx.bind({ $0.lightBackgroundColor }, to: tabBar.rx.barTintColor)
    }
    
    class func swichTo() {
        let window = UIApplication.shared.delegate?.window
        window??.rootViewController = RootTabBarController()
    }
}

extension RootTabBarController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let traitCollection = previousTraitCollection else { return }
        
        /// appTheme 自动跟随系统
        let isDark = traitCollection.userInterfaceStyle == .dark
        let themeType: ThemeType = isDark ? .light : .dark
        if themeType != appTheme.type {
            appTheme.switch(themeType)
        }
    }
}

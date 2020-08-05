//
//  Rx.swift
//  CursApp
//
//  Created by lailiang on 2020/3/14.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UINavigationBar {
    var barBackgroundColor: Binder<UIColor?> {
        return Binder<UIColor?>(self.base) { (bar, color) in
            let bgColor = color ?? .white
            let bgImage = bgColor.mapImage
            bar.setBackgroundImage(bgImage, for: .default)
        }
    }
    var titleColor: Binder<UIColor?> {
        return Binder<UIColor?>(self.base) { (bar, color) in
            bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color ?? .black]
        }
    }
}

extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { (_) -> Observable<Element> in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func filterNil<E>() -> Observable<E> where Element == E? {
        return self.filter { $0 != nil }.map { $0! }
    }
}

//
//  ViewModel.swift

//
//  Created by lailiang on 2020/7/15.
//  Copyright © 2020 lailiang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
        
    func transform(input: Input) -> Output
}

class ViewModel {
    
    let disposeBag = DisposeBag()
    
    lazy var loading = ActivityIndicator()
    lazy var error = ErrorTracker()
}

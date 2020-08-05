//
// Created by lailiang on 2020/7/17.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit

class MyEditViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "保存"
        self.navigationItem.rightBarButtonItem = backItem
    }
}
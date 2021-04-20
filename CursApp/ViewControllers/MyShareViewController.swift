//
//  MyShareViewController.swift

//
//  Created by lailiang on 2020/4/8.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit
import CRBoxInputView

class MyShareViewController: BaseViewController {
    @IBOutlet weak var codeInputView: CRBoxInputView!
    
    @IBOutlet weak var dummyLabel: UILabel!

//    var tableView: CRBoxInputView = {
//        let tableView = CRBoxInputView.init(codeLength: 6)
//        tableView?.loadAndPrepare(withBeginEdit: true)
//        return tableView!
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyLabel.text = "From Story Board"

        codeInputView.loadAndPrepare()
        codeInputView.mainCollectionView()?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        codeInputView.resetCodeLength(6, beginEdit: true)

//        self.view.addSubview(tableView)
//        tableView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.right.equalToSuperview()
//            make.height.equalTo(200)
//        }

    }
}

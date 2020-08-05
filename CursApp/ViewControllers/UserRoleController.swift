//
// Created by apple on 2020/7/24.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UserRoleController : BaseViewController {
    struct ListItem {
        let title: String
        let vcProvider: () -> UIViewController
        init(title: String,
             viewController: @escaping @autoclosure () -> UIViewController
        ) {
            self.title = title
            self.vcProvider = viewController
        }
    }

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    lazy var dataSource = getDataSource()

    private var currentTheme: Theme?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-24)
        }

        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5

        Observable.just(fetchData())
                .asDriver(onErrorJustReturn: [])
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)

//        tableView.rx.modelSelected(ListItem.self).subscribe(onNext: { [weak self] item in
//                    let toVC = item.vcProvider()
//                    toVC.hidesBottomBarWhenPushed = true
//                    toVC.title = item.title
//                    self?.navigationController?.pushViewController(toVC, animated: true)
//                })
//                .disposed(by: disposeBag)

        appTheme.attrsStream.subscribe(onNext: { [weak self] theme in
                    self?.currentTheme = theme
                    self?.tableView.reloadData()
                })
                .disposed(by: disposeBag)

    }
}

/// private
extension UserRoleController {
    func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Void, ListItem>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<Void, ListItem>>(configureCell: { [weak self] (ds, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            let theme = self?.currentTheme
            cell.textLabel?.text = item.title
            cell.accessoryType = .none
            cell.tintColor = .gray
            cell.backgroundColor = theme?.lightBackgroundColor
            cell.textLabel?.textColor = theme?.textColor
            return cell
        })
    }

    func fetchData() -> [SectionModel<Void, ListItem>] {
        let section1Items = [
            ListItem(
                    title: "易结二期机场业务部管理员",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "特殊场景业务",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "ACCA管理员",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "表单管理员",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "易结管理员",
                    viewController: MyEditViewController()
            )
        ]

        let sectionModels = [section1Items].map {
            SectionModel(model: (), items: $0)
        }
        return sectionModels
    }
}
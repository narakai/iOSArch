//
// Created by lailiang on 2020/7/17.
// Copyright (c) 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BasicInfoViewController: BaseViewController {
    struct ListItem {
        let title: String
        let desc: String
        let vcProvider: () -> UIViewController
        init(title: String, desc: String,
             viewController: @escaping @autoclosure () -> UIViewController
        ) {
            self.title = title
            self.desc = desc
            self.vcProvider = viewController
        }
    }

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    lazy var dataSource = getDataSource()

    private var currentTheme: Theme?

    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem()
        backItem.title = "保存"
        self.navigationItem.rightBarButtonItem = backItem

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-24)
        }

        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50

        tableView.register(BasicInfoTableViewCell.self, forCellReuseIdentifier: "BasicInfoTableViewCell")

        Observable.just(fetchData())
                .asDriver(onErrorJustReturn: [])
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)

        tableView.rx.modelSelected(ListItem.self).subscribe(onNext: { [weak self] item in
                    let toVC = item.vcProvider()
                    toVC.hidesBottomBarWhenPushed = true
                    toVC.title = item.title
                    self?.navigationController?.pushViewController(toVC, animated: true)
                })
                .disposed(by: disposeBag)

        appTheme.attrsStream.subscribe(onNext: { [weak self] theme in
                    self?.currentTheme = theme
                    self?.tableView.reloadData()
                })
                .disposed(by: disposeBag)

    }
}

/// private
extension BasicInfoViewController {
    func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Void, ListItem>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<Void, ListItem>>(configureCell: { [weak self] (ds, tableView, indexPath, item) -> BasicInfoTableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoTableViewCell", for: indexPath) as! BasicInfoTableViewCell
            cell.selectionStyle = .none
            let theme = self?.currentTheme
            cell.titleLabel.text = item.title + ":"
            cell.descLabel.text = item.desc
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = .gray
            let image = UIImage(named:"disclosureArrow")?.withRenderingMode(.alwaysTemplate)
            if let width = image?.size.width, let height = image?.size.height {
                let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                disclosureImageView.image = image
                cell.accessoryView = disclosureImageView
            }
            cell.backgroundColor = theme?.lightBackgroundColor
            cell.titleLabel.textColor = theme?.textColor
            cell.descLabel.textColor = theme?.textColor
//            cell.descLabel.backgroundColor = UIColor.gray
//            cell.titleLabel.backgroundColor = UIColor.blue
            return cell
        })
    }

    func fetchData() -> [SectionModel<Void, ListItem>] {
        let section1Items = [
            ListItem(
                    title: "用户ID",
                    desc: "xxx@aa.com",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "用户姓名",
                    desc: "呵呵",
                    viewController: MyEditViewController()
            )
        ]
        let section2Items = [
            ListItem(
                    title: "Email",
                    desc: "xxx@aa.com",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "性别",
                    desc: "男",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "生日",
                    desc: "1992-01-01",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "邮编",
                    desc: "610000",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "电话",
                    desc: "028-10002222",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "移动电话",
                    desc: "13333333333",
                    viewController: MyEditViewController()
            )
        ]
        let section3Items = [
            ListItem(
                    title: "组织结构",
                    desc: "AA",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "开始日期",
                    desc: "1992-01-01",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "截止日期",
                    desc: "1992-01-01",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "创建日期",
                    desc: "xxx@aa.com",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "地址",
                    desc: "浏览地图、搜索地点、查询公交驾车线路、查看实时路况,您的出行指南、生活助手。提供地铁线路图浏览,乘车方案查询,以及准确的票价和时间信息",
                    viewController: MyEditViewController()
            ),
            ListItem(
                    title: "描述",
                    desc: "浏览地图、搜索地点、查询公交驾车线路、查看实时路况,您的出行指南、生活助手。提供地铁线路图浏览,乘车方案查询,以及准确的票价和时间信息",
                    viewController: MyEditViewController()
            )
        ]

        let sectionModels = [section1Items, section2Items, section3Items].map {
            SectionModel(model: (), items: $0)
        }
        return sectionModels
    }
}

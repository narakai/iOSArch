//
//  HomeViewController.swift

//
//  Created by lailiang on 2020/7/15.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Toaster

class MineViewController: BaseViewController {

    struct ListItem {
        let icon: Iconfont
        let title: String
        let iconColor: UIColor?
        let vcProvider: () -> UIViewController

        init(title: String,
             iconFont: Iconfont,
             viewController: @escaping @autoclosure () -> UIViewController,
             iconColor: UIColor? = nil
        ) {
            self.icon = iconFont
            self.title = title
            self.iconColor = iconColor
            self.vcProvider = viewController
        }
    }

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    lazy var dataSource = getDataSource()

    private var currentTheme: Theme?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarHidden = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-24)
        }

        Observable.just(fetchData())
                .asDriver(onErrorJustReturn: [])
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)

        tableView.rx.modelSelected(ListItem.self).subscribe(onNext: { [weak self] item in
                    #if DEBUG
                    let toVC = item.vcProvider()
                    toVC.hidesBottomBarWhenPushed = true
                    toVC.title = item.title
                    self?.navigationController?.pushViewController(toVC, animated: true)
                    #else
                    if !AppState.share.loginUser.value.isLogin && item.title != "设置" {
                        Toast(text: "请先登录", duration: Delay.short).show()
                    } else {
                        let toVC = item.vcProvider()
                        toVC.hidesBottomBarWhenPushed = true
                        toVC.title = item.title
                        self?.navigationController?.pushViewController(toVC, animated: true)
                    }
                    #endif
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
extension MineViewController {
    func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Void, ListItem>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<Void, ListItem>>(configureCell: { [weak self] (ds, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            let theme = self?.currentTheme
            cell.imageView?.image = item.icon.image(size: 20, color: (item.iconColor ?? theme?.primaryColor) ?? .blue)
            cell.textLabel?.text = item.title
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = theme?.lightBackgroundColor
            cell.textLabel?.textColor = theme?.textColor

            cell.tintColor = .gray
            let image = UIImage(named: "disclosureArrow")?.withRenderingMode(.alwaysTemplate)
            if let width = image?.size.width, let height = image?.size.height {
                let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                disclosureImageView.image = image
                cell.accessoryView = disclosureImageView
            }

            return cell
        })
    }

    func fetchData() -> [SectionModel<Void, ListItem>] {
        let section1Items = [
            ListItem(
                    title: "基本信息",
                    iconFont: .integral,
                    viewController: BasicInfoViewController()
            ),
            ListItem(
                    title: "用户角色",
                    iconFont: .share,
                    viewController: UserRoleController()
            ),
            ListItem(
                    title: "修改密码",
                    iconFont: .heart,
                    viewController: ChangePasswordViewController.fromStoryboard()!
            )
        ]
        let section2Items = [
            ListItem(
                    title: "设置",
                    iconFont: .setting,
                    viewController: SettingsViewController()
            )
        ]

        let sectionModels = [section1Items, section2Items].map {
            SectionModel(model: (), items: $0)
        }
        return sectionModels
    }
}

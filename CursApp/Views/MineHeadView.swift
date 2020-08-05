//
//  MineHeadView.swift
//  CursApp
//
//  Created by lailiang on 2020/3/30.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Kingfisher

class MineHeadView: UIView {

    var headImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "avatar")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 45
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()

    var userNameBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.largeTitle
        btn.setTitle("点击登录", for: .normal)
        return btn
    }()

    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.subTitle
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeFlexLayout { (make) in
            make.flexDirection(.column).alignItems(.center).justifyContent(.center).padding(12)
            make.addChild(self.headImgView).width(90).aspectRatio(1.0)
            make.addChild(self.userNameBtn).marginTop(12)
            make.addChild(self.infoLabel)
        }
        yoga.adjustsViewHierarchy()

        appTheme.rx
                .bind({ $0.textColor }, to: userNameBtn.rx.titleColor(for: .normal))
                .bind({ $0.subTextColor }, to: infoLabel.rx.textColor)
                .bind({ $0.lightBackgroundColor }, to: headImgView.rx.backgroundColor)
                .disposed(by: rx.disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        yoga.applyLayout(preservingOrigin: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MineHeadView {
    func setSubviewsInfos(with user: UserInfoBean) {
        if user.isLogin {
            userNameBtn.setTitle(user.userName, for: .normal)
            if let department = user.rootOrgainzationCode {
                let infos = "组织结构: " + department
                infoLabel.text = infos
            }
            if let imageUrl = user.userPic {
                let downloader = KingfisherManager.shared.downloader //Downloader needs to be configured to accept untrusted certificates
                downloader.trustedHosts = Set(["10.1.17.140"])
                headImgView.kf.setImage(with: URL(string: "https://10.1.17.140:8443/api/user-management/download" + imageUrl)!,
                        placeholder: UIImage(named: "avatar"),
                        options: [.downloader(downloader)])
//                                  .processor(RoundCornerImageProcessor(cornerRadius: 50))])
            }
        } else {
            userNameBtn.setTitle("点击登录", for: .normal)
            infoLabel.text = "组织结构:"
            headImgView.image = UIImage(named: "avatar")
        }
        yoga.markChildrenDirty()
        setNeedsLayout()
    }

    var bindUser: Binder<UserInfoBean> {
        return Binder<UserInfoBean>(self) { (view, user) in
            view.setSubviewsInfos(with: user)
        }
    }
}

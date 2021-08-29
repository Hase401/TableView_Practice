//
//  MySwitcherViewController+setup.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/30.
//

extension MySwitcherViewController {

    func setup() {
        // 【疑問】順番を逆にするだけで呼ばれるメソッドの順番も変わりコンソールに出力される結果も多少変わってくる
        // 【原因について仮設】addSubviewした順番(最後にaddしたViewほど先にlayoutSubViews()が呼ばれる？)
        setupSegementSlideContentView()
        setupSegementSlideSwitcherView()
//        setupSegementSlideContentView() // 呼ぶ順番を変える
    }

    func setupSegementSlideSwitcherView() {
        // 【疑問】customViewの設定方法は、addSubviewしてから色々な成約をつけるという順番？
        mySwitcherView.delegate = self
        self.view.addSubview(mySwitcherView)
    }

    func setupSegementSlideContentView() {
        mySwitcherContentView.delegate = self
        mySwitcherContentView.viewController = self
        self.view.addSubview(mySwitcherContentView)
    }


    func layoutSegementSlideScrollView() {

        mySwitcherView.translatesAutoresizingMaskIntoConstraints = false
        // 【エラー】Value of type 'MySwitcherView' has no member 'topConstraint' // Extensionのおかげ？
        // これがあると紫の警告が消える？？
        if mySwitcherView.topConstraint == nil {
            mySwitcherView.topConstraint = mySwitcherView.topAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor)
        }
        if mySwitcherView.leadingConstraint == nil {
            mySwitcherView.leadingConstraint = mySwitcherView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if mySwitcherView.trailingConstraint == nil {
            mySwitcherView.trailingConstraint = mySwitcherView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        if mySwitcherView.heightConstraint == nil {
            mySwitcherView.heightConstraint = mySwitcherView.heightAnchor.constraint(equalToConstant: switcherHeight)
        } else {
            if mySwitcherView.heightConstraint?.constant != switcherHeight {
                mySwitcherView.heightConstraint?.constant = switcherHeight
            }
        }


        mySwitcherContentView.translatesAutoresizingMaskIntoConstraints = false
        if mySwitcherContentView.topConstraint == nil {
            mySwitcherContentView.topConstraint = mySwitcherContentView.topAnchor.constraint(equalTo: mySwitcherView.bottomAnchor)
        }
        if mySwitcherContentView.leadingConstraint == nil {
            mySwitcherContentView.leadingConstraint = mySwitcherContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if mySwitcherContentView.trailingConstraint == nil {
            mySwitcherContentView.trailingConstraint = mySwitcherContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        if mySwitcherContentView.bottomConstraint == nil {
            mySwitcherContentView.bottomConstraint = mySwitcherContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }

        mySwitcherContentView.layer.zPosition = -2
        mySwitcherView.layer.zPosition = -1

    }
}

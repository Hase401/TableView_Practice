//
//  MySwitcherViewController.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/30.
//

import UIKit

final class MySwitcherViewController: UIViewController {

    static func instantiate() -> MySwitcherViewController {
        guard let vc = UIStoryboard(name: "SecondMyData", bundle: nil).instantiateInitialViewController() as? MySwitcherViewController else {
            fatalError("MySwitcherViewControllerが見つかりません")
        }
        return vc
    }

    let mySwitcherView = MySwitcherView()
    let mySwitcherContentView = MySwitcherContentView()

    var switcherHeight: CGFloat {
        // 【メモ】getのみだから省略可
        return 44
    }
    var titleMySwitcherView: [String]? = []
    // 【エラー】Members of 'final' classes are implicitly 'final'; use 'public' instead of 'open'
    // 【解決】classがfinalで継承禁止にしているのにopenで継承可にしてしまっている　→　public or internal(アクセス制御を何も何も書かない場合のデフォルト)
    var defaultSelectedIndex: Int? {
        didSet {
            // 【メモ】変更しているのは、ViewDidLoadでdefaultSelectedIndex = 0 として読んだところのみ
            mySwitcherView.defaultSelectedIndex = defaultSelectedIndex
            mySwitcherContentView.defaultSelectedIndex = defaultSelectedIndex
        }
    }

    /// ビューコントローラーのビューのboundsが変更されると、ビューはそのサブビューの位置を調整し、システムはこのメソッドを呼び出す
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSegementSlideScrollView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "4169E1")
        self.navigationItem.title = "テンプレート設定"

        setup()
        defaultSelectedIndex = 0
        titleMySwitcherView = mySwitcherView.titlesInSegementSlideSwitcherView
        // ScrollViewの中身にButtonなどの情報を設定する
        // 【メモ】reloadSubViews()はprivateだからreloadData()を挟む
        mySwitcherView.reloadData()
    }

    // 【修正】ContentViewDelegate → ContentViewController
    func segementSlideContentViewController(at index: Int) -> ContentViewController? {
        let contentVC = UIStoryboard(name: "ContentViewController", bundle: nil)
                            .instantiateInitialViewController() as! ContentViewController
        // 【エラー】Type of expression is ambiguous without more context
        // 【解決】ContentViewControllerにContentViewDelegateを継承させる
        return contentVC
    }

}

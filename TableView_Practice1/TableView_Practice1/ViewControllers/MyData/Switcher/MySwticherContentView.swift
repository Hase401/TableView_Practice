//
//  MySwticherContentView.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/30.
//

import UIKit

// 【疑問】プロトコルでviewControllersの中身の型を設定できるのではないか？
//protocol ContentViewDelegate where Self: UIViewController {
//
//}

// 【エラー】Method cannot be declared public because its result uses an internal type
// → このプロトコルをpublicにするとMySwitcherContentViewメソッドのアクセス制御が合わなくてエラーになる
protocol SegementSlideContentDelegate: AnyObject {

    var segementSlideContentScrollViewCount: Int { get }

    // 【修正】ContentViewDelegate → ContentViewController
    func segementSlideContentScrollView(at index: Int) -> ContentViewController?

    func segementSlideContentView(_ segementSlideContentView: MySwitcherContentView, didSelectAtIndex index: Int, animated: Bool)

}


final class MySwitcherContentView: UIView {
    private(set) var scrollView = UIScrollView()
    // 【疑問】プロトコルでviewControllersの中身の型を設定できるのではないか？
    // 【疑問】逆にContentViewControllerの型でも行けるんじゃないか？
    // 【修正】ContentViewDelegate → ContentViewController
    private var viewControllers: [Int: ContentViewController] = [:]

    /// you should call `reloadData()` after set this property.
    var defaultSelectedIndex: Int?
    private(set) var selectedIndex: Int?
    // 【疑問】弱参照になっている一連の処理はどうなっているのか？
    weak var viewController: UIViewController?
    weak var delegate: SegementSlideContentDelegate?

    // 【疑問】　このプロパティを用意しているのは、scrollViewの中のプロパティをContentViewのスコープ内にも持たせたいから？
    var isScrollEnabled: Bool {
        get {
            return scrollView.isScrollEnabled
        }
        set {
            scrollView.isScrollEnabled = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(scrollView)
        scrollView.constraintToSuperview()
        // 【追加②】contentViewをscrollしたときの動作
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        backgroundColor = .white
    }

    // 【疑問】なぜ、2回も呼ばれているのか？
    override func layoutSubviews() {
        super.layoutSubviews()
        // 【追加④】contentViewをscrollしたときの動作
        updateScrollViewContentSize()
        updateSelectedIndex()
    }

    // 【メモ】mySwitcherViewのdelegateで呼ばれる実際のメソッド
    // 【メモ】privateのupdateSelectedViewControllerを呼んでいる
    func selectItem(at index: Int, animated: Bool) {
        updateSelectedViewController(at: index, animated: animated)
    }

    // 【修正】ContentViewDelegate → ContentViewController
    func dequeueReusableViewController(at index: Int) -> ContentViewController? {
        if let childViewController = viewControllers[index] {
            // viewControllers[index]がnilではないとき
            return childViewController
        } else {
            // viewControllers[index]がnilのとき
            return nil
        }
    }
}

// 【追加①】contentViewをscrollしたときの動作
extension MySwitcherContentView: UIScrollViewDelegate {

    /// スクロールビューでのドラッグが終了したとき、デリゲートに通知
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // ドラッグ操作中にタッチアップジェスチャーを行った後、スクロールの動きを継続しながら減速する場合はtrue
        // decelerateがtrueなので毎回returnされている
        // falseを指定すると、タッチアップ時にスクロールを停止
        if decelerate { return }
        scrollViewDidEndScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }

    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let indexFloat = scrollView.contentOffset.x/scrollView.bounds.width
        guard !indexFloat.isNaN, indexFloat.isFinite else {
            return
        }
        let index = Int(indexFloat)
        updateSelectedViewController(at: index, animated: true)
    }

}

extension MySwitcherContentView {

    // 【追加③】contentViewをscrollしたときの動作
    // 【メモ】横スクロールするためにもscrollViewのcontentSizeがしっかりcount*scrollView.bounds.widthになっていないといけない
    private func updateScrollViewContentSize() {
        guard let count = delegate?.segementSlideContentScrollViewCount else {
            return
        }
        let contentSize = CGSize(width: CGFloat(count)*scrollView.bounds.width, height: scrollView.bounds.height)
        guard scrollView.contentSize != contentSize else {
            // すでにscrollView.contentSize == contentSizeならばreturnする
            return
        }
        scrollView.contentSize = contentSize
    }

    private func updateSelectedIndex() {
        if let index = selectedIndex  {
            updateSelectedViewController(at: index, animated: false)
        } else if let index = defaultSelectedIndex {
            updateSelectedViewController(at: index, animated: false)
        }
    }

    // 【メモ】同じ名前のメソッドがviewControllerにもある
    // 【修正】ContentViewDelegate → ContentViewController
    private func segementSlideContentViewController(at index: Int) -> ContentViewController? {
        if let childViewController = dequeueReusableViewController(at: index) {
            // viewControllers(配列)に何かしらある(つまりnil)ではないなら、そのContentViewDelegateを返す
            return childViewController
        } else if let childViewController = delegate?.segementSlideContentScrollView(at: index) {
            viewControllers[index] = childViewController
            return childViewController
        }
        return nil
    }

    private func updateSelectedViewController(at index: Int, animated: Bool) {
        print("==================== Start updateSelectedViewController() ====================")
        print("index: ", index)
        print("selectedIndex: ", selectedIndex)
        print("defaultSelectedIndex: ", defaultSelectedIndex)
        print("contentView scrollView.frame: ", scrollView.frame)
        // frameが.zeroだったらreturnさせる
        guard scrollView.frame != .zero else {
            print("========== scrollView.frame = .zero → updateSelectedViewController() return ==========")
            return
        }
        // 同じButtonをタップしていたら（index = selectedIndexだったら）returnさせる
        guard index != selectedIndex else {
            print("=========== index == selectedIndex → updateSelectedViewController() return ==========")
            return
        }
        let count = delegate?.segementSlideContentScrollViewCount ?? 0 // 4
        if let selectedIndex = selectedIndex {
            // selectedIndexがnilじゃなかったら
            guard selectedIndex >= 0, selectedIndex < count else {
                return
            }
        }
        guard let viewController = viewController,
            index >= 0, index < count else {
            return
        }

        // 【疑問】ライフサイクルの更新始まり?
        if let lastIndex = selectedIndex,
           let lastChildViewController = segementSlideContentViewController(at: lastIndex) {
            // 【疑問】もしnilだったら、、last child viewController viewWillDisappearを呼ぶ？
            // 【メモ】子のビューが現れたり消えたりするのを伝える
            // 【メモ】viewWillAppear(_:), viewWillDisappear(_:), viewDidAppear(_:), viewDidDisappear(_:) を直接起動しない
            // 【メモ】子ビューコントローラのビューがビュー階層に追加されようとしている場合はtrue, 削除されようとしている場合はfalse
            lastChildViewController.beginAppearanceTransition(false, animated: animated)
        }
        guard let childViewController = segementSlideContentViewController(at: index) else {
            return
        }
        // superViewがnilじゃないならtrue, nilならfalse
        let isAdded = childViewController.view.superview != nil // Bool値
        if !isAdded {
            // superviewがnilなら、、addChildする(現在のビューコントローラの子として追加)
            // new child viewController viewDidLoad, viewWillAppear
            viewController.addChild(childViewController)
            scrollView.addSubview(childViewController.view)
        } else {
            // 【疑問】superviewがnilじゃないなら、現在のchildVCのviewWillAppearが呼ばれる？
            // current child viewController viewWillAppear
            childViewController.beginAppearanceTransition(true, animated: animated)
        }

        // viewControllerの数(buttonの数)だけ横幅がある
        let offsetX = CGFloat(index)*scrollView.bounds.width
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.topConstraint = childViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor)
        childViewController.view.widthConstraint = childViewController.view.widthAnchor.constraint(equalToConstant: scrollView.bounds.width)
        childViewController.view.heightConstraint = childViewController.view.heightAnchor.constraint(equalToConstant: scrollView.bounds.height)
        childViewController.view.leadingConstraint = childViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: offsetX)
        // 【疑問】これは何？
        // 受信者の原点に対応するコンテンツビューの原点からのオフセットを設定
        // setContentOffsetで横にスクロールできるScrollViewの始まりを指摘しているのかな？
        scrollView.setContentOffset(CGPoint(x: offsetX, y: scrollView.contentOffset.y), animated: animated)

        // 【疑問】ライフサイクルの更新終わり?
        if let lastIndex = selectedIndex,
           let lastChildViewController = segementSlideContentViewController(at: lastIndex) {
            // last child viewController viewDidDisappear
            lastChildViewController.endAppearanceTransition()
        }
        if !isAdded {
            ()
        } else {
            // current child viewController viewDidAppear
            childViewController.endAppearanceTransition()
        }

        // selectedIndexを現在のものに更新する
        selectedIndex = index
        print("selectedIndex: ", selectedIndex)

        // 【新重要メモ】恐らくこれでスクロールしたときのswitcherViewを呼んで表示するように設定している
        // プロトコルに新しくsegementSlideContentView()のメソッドを追加する必要がある
        // 【追加①】
        delegate?.segementSlideContentView(self, didSelectAtIndex: index, animated: animated)
        print("=================== End updateSelectedViewController() =====================")

    }
}

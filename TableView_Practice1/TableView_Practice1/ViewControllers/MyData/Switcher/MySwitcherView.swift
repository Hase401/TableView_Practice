//
//  MySwitcherView.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/30.
//

import UIKit

protocol SegementSlideDefaultSwitcherViewDelegate: AnyObject {

    func segementSwitcherView(_ segementSlideSwitcherView: MySwitcherView, didSelectAtIndex index: Int, animated: Bool)

}

// 【メモ】CustomViewなのでイニシャライザが必要
final class MySwitcherView: UIView {

    var scrollView = UIScrollView()
    private let indicatorView = UIView()
    private var titleButtons: [UIButton] = []
    // 【疑問メモ】classではなく、structで共通化する方法どうするんだっけ？(サロンのどこかのSlackにあった気がする)
    private var innerConfig: MySwitcherConfig = MySwitcherConfig()

    // 【疑問】ここだけ変えれば、自動で調整してくれる？？？
    // 【メモ】オプショナル型にしないとguard letが使えなくて安全性を保てない
    var titlesInSegementSlideSwitcherView: [String]? = ["朝ルーティン", "夜ルーティン"]
    // 【重要メモ】このdelegateでsegementSwitcherView()をbuttonタップしたときに呼んでいる
    weak var delegate: SegementSlideDefaultSwitcherViewDelegate?

    /// you should call `reloadData()` after set this property.
    var defaultSelectedIndex: Int?
    private(set) var selectedIndex: Int?

    // 【疑問】これがなくても動くが、、本当に必要なのか？
    override var intrinsicContentSize: CGSize {
        return scrollView.contentSize
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
        // ビュー階層の一番上にある
        addSubview(scrollView)
        scrollView.constraintToSuperview()
        // 水平スクロールインジケータが表示されているかどうかを制御するブール値
        scrollView.showsHorizontalScrollIndicator = false
        // 垂直スクロールインジケータが表示されているかどうかを制御するブール値
        scrollView.showsVerticalScrollIndicator = false
        // 上部へのスクロールジェスチャーを有効にするかどうかを制御するブール値
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = .clear
        backgroundColor = .white
    }

    // 【疑問】なぜ、2回も呼ばれているのか？
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadContents()
        updateSelectedIndex()
    }

    func reloadData() {
        // 【メモ】private化されているのでこのMySwitcherView内で呼ぶ
        reloadSubViews()
    }

    func selectItem(at index: Int, animated: Bool) {
        // 【メモ】private化されているのでこのMySwitcherView内で呼ぶ
        updateSelectedButton(at: index, animated: animated)
    }

}

extension MySwitcherView {

    private func updateSelectedIndex() {
        if let index = selectedIndex  {
            updateSelectedButton(at: index, animated: false)
        } else if let index = defaultSelectedIndex {
            updateSelectedButton(at: index, animated: false)
        }
    }

    /// buttonとindicatorViewをscrollView.addSubView()する
    private func reloadSubViews() {

        /// buttonとindicatorViewの初期化
        for titleButton in titleButtons {
            // スーパービューおよびウィンドウからビューのリンクを解除し、レスポンダチェーンからビューを削除
            // ビューのスーパービューがnilでない場合、スーパービューはビューを解除
            // 削除しているビューを参照している制約や、削除しているビューのサブツリー内の任意のビューを参照している制約がすべて削除
            titleButton.removeFromSuperview()
            titleButton.frame = .zero
        }
        titleButtons.removeAll()
        indicatorView.removeFromSuperview()
        indicatorView.frame = .zero

        // titles.isEmptyがtureだったらreturnさせたいので、、、
        // 2重否定で、tureじゃない場合"じゃなかったら"returnさせる(trueだったらreturn)　// わかりづらい
        guard let titles = titlesInSegementSlideSwitcherView,
              !titles.isEmpty else {
            return
        }

        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            // falseだと、フレームが受信機の可視範囲を超えているサブビューはクリップされない
            // デフォルトの値は false
            button.clipsToBounds = false
            button.titleLabel?.font = innerConfig.normalTitleFont
            button.backgroundColor = .clear
            button.setTitle(title, for: .normal)
            // ここで順番を伝える
            button.tag = index
            button.setTitleColor(innerConfig.normalTitleColor, for: .normal)
            button.addTarget(self, action: #selector(didClickTitleButton), for: .touchUpInside)
            scrollView.addSubview(button)
            titleButtons.append(button)
        }

        // 【疑問】indicatorViewはどこに表示するかの成約がまだでは？
        scrollView.addSubview(indicatorView)
        // サブレイヤーがレイヤーの境界にクリッピングされるかどうかを示すブール値
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = innerConfig.indicatorHeight/2
        indicatorView.backgroundColor = innerConfig.indicatorColor
    }

    private func reloadContents() {
        // .zeroだったらreturn
        guard scrollView.frame != .zero else {
            return
        }
        // .isEmptyがtureだったらreturn // self.bounds.width
        guard !titleButtons.isEmpty else {
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height)
            return
        }

        // titleButtonをframeのx座標として設定するのに必要
        var offsetX = innerConfig.horizontalMargin
        // 【疑問メモ】titleButton.frame = .zeroしていたのでここで設定してあげる必要がある？
        for titleButton in titleButtons {
            let buttonWidth: CGFloat
            buttonWidth = (bounds.width-innerConfig.horizontalMargin*2)/CGFloat(titleButtons.count)
            // 【疑問】self.bounds.heightではなく、scrollView.bounds.heightなのはsuperViewだから？
            titleButton.frame = CGRect(x: offsetX, y: 0, width: buttonWidth, height: scrollView.bounds.height)
            offsetX += buttonWidth

        }

        scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height)
    }

    // 【メモ】ボタンタップ後の動きを設定している(なんとanimationを使っていた！)
    private func updateSelectedButton(at index: Int, animated: Bool) {
        print("-------------------- Start updateSelectedButton() ---------------------")
        print("index: ", index)
        print("selectedIndex: ", selectedIndex)
        print("defaultSelectedIndex: ", defaultSelectedIndex)
        print("switcherView scrollView.frame: ", scrollView.frame)
        guard scrollView.frame != .zero else {
            print("---------- scrollView.frame = .zero → updateSelectedButton() return ----------")
            return
        }
        // 【メモ】同じところをタップしたらreturnさせる
        guard index != selectedIndex else {
            print("---------- index == selectedIndex → updateSelectedButton() return ----------")
            return
        }

        let count = titleButtons.count
        // nil(初期画面)以外ならさっきまでseletctedされていたButtonのconfigをnormalに戻す
        if let selectedIndex = selectedIndex {
            // selectedIndexが0より小さいか、selectedIndexがcount以上か、どちら片方でも成り立つ異常事態ならreturnする
            guard selectedIndex >= 0, selectedIndex < count else {
                return
            }
            let selectedTitleButton = titleButtons[selectedIndex]
            selectedTitleButton.setTitleColor(innerConfig.normalTitleColor, for: .normal)
            selectedTitleButton.titleLabel?.font = innerConfig.normalTitleFont
        }
        // 選ばれたindex(button.tag)が0より小さいか、count以上の異常事態ならreturnする
        guard index >= 0, index < count else {
            return
        }
        // 選ばれているbuttonに対してconfigをselectedにする
        let titleButton = titleButtons[index]
        titleButton.setTitleColor(innerConfig.selectedTitleColor, for: .normal)
        titleButton.titleLabel?.font = innerConfig.selectedTitleFont

        if animated, indicatorView.frame != .zero {
            UIView.animate(withDuration: 0.25) {
                self.indicatorView.frame =
                    // 【疑問】originを使うタイミングはいつがいいのか？
                    // 【回答】subview(今回でいうindicatorView)の映す位置を変えたいとき
                    // 【メモ】クロージャ＝なのでselfが必要
                    CGRect(x:titleButton.frame.origin.x+(titleButton.bounds.width-self.innerConfig.indicatorWidth)/2,
                           y: self.frame.height-self.innerConfig.indicatorHeight,
                           width: self.innerConfig.indicatorWidth,
                           height: self.innerConfig.indicatorHeight)
            }
        } else {
            // animationを使わない場合も記述する必要がある
            indicatorView.frame =
                CGRect(x:titleButton.frame.origin.x+(titleButton.bounds.width-innerConfig.indicatorWidth)/2,
                       y: frame.height-innerConfig.indicatorHeight,
                       width: innerConfig.indicatorWidth,
                       height: innerConfig.indicatorHeight)
        }

        // selectedIndexを現在のものに更新する
        self.selectedIndex = index
        print("selectedIndex: ", selectedIndex)

        delegate?.segementSwitcherView(self, didSelectAtIndex: index, animated: animated)
        print("--------------------- End updateSelectedButton ---------------------")
    }

    // 【メモ】buttonを引数にすることでbutton.tagが使える
    @objc
    private func didClickTitleButton(_ button: UIButton) {
        selectItem(at: button.tag, animated: true)
    }

}

//
//  MySwitcherViewController+delegate.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/30.
//

extension MySwitcherViewController: SegementSlideContentDelegate {

    var segementSlideContentScrollViewCount: Int {
        return titleMySwitcherView?.count ?? 0
    }

    // 【修正】ContentViewDelegate → ContentViewController
    func segementSlideContentScrollView(at index: Int) -> ContentViewController? {
        // ContentViewController(ContentViewDelegate)を返す
        return segementSlideContentViewController(at: index)
    }

    // 【追加③】
    // 【重要メモ】これだけではscrollできない！！ContentViewのscrollViewのcontentSizeが鍵になってくる
    func segementSlideContentView(_ segementSlideContentView: MySwitcherContentView, didSelectAtIndex index: Int, animated: Bool) {
        if mySwitcherView.selectedIndex != index {
            mySwitcherView.selectItem(at: index, animated: animated)
        }
    }

}

/// switcherViewのタbuttonタップ時に呼ばれるdelegateメソッド
extension MySwitcherViewController: SegementSlideDefaultSwitcherViewDelegate {

    public func segementSwitcherView(_ segementSlideSwitcherView: MySwitcherView, didSelectAtIndex index: Int, animated: Bool) {
        if mySwitcherContentView.selectedIndex != index {
            mySwitcherContentView.selectItem(at: index, animated: animated)
        }
    }

}

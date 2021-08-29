//
//  MySwitcherConfig.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/30.
//

import UIKit

struct MySwitcherConfig {

    var horizontalMargin: CGFloat
    var normalTitleFont: UIFont
    var selectedTitleFont: UIFont
    var normalTitleColor: UIColor
    var selectedTitleColor: UIColor
    var indicatorWidth: CGFloat
    var indicatorHeight: CGFloat
    var indicatorColor: UIColor


    // 【疑問】最初から初期値として与えてやり方は、良くないのか？
    //  インスタンスにstaticをつける場合からしたら良いやり方と言える？
    init(horizontalMargin: CGFloat = 16,
         normalTitleFont: UIFont = UIFont.systemFont(ofSize: 15),
         selectedTitleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .medium),
         normalTitleColor: UIColor = UIColor.gray,
         selectedTitleColor: UIColor = UIColor.blue,
         indicatorWidth: CGFloat = 30,
         indicatorHeight: CGFloat = 2,
         indicatorColor: UIColor = UIColor.orange) {
        self.horizontalMargin = horizontalMargin
        self.normalTitleFont = normalTitleFont
        self.selectedTitleFont = selectedTitleFont
        self.normalTitleColor = normalTitleColor
        self.selectedTitleColor = selectedTitleColor
        self.indicatorWidth = indicatorWidth
        self.indicatorHeight = indicatorHeight
        self.indicatorColor = indicatorColor
    }
}

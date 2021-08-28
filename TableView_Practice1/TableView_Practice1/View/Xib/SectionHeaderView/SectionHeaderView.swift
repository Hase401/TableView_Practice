//
//  SectionHeaderView.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/27.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    static let identifier = "SectionHeaderView"
    static func nib() -> UINib {
        UINib(nibName: "SectionHeaderView", bundle: nil)
    }

    // 削除
//    var sectionHeaders: [SectionHeader]!
//    var sectionNumber: Int?
//    var showCellButtonHandler: () -> Void = {}
//    var showCellButtonHandler: (Bool) -> Void = { _ in }

    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .systemGray6

        // 削除
//        sectionHeaders = MyPageViewController.yearFile
        setupToggleImageView()
    }

    private func setupToggleImageView() {
        // 【設定】scale = large, weight = bold
        imageView.tintColor = UIColor(hex: "4169E1")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        yearLabel.text = nil
    }
    
    func configure(sectionHeader: SectionHeader) {
        yearLabel.text = String(sectionHeader.year)+"年"
    }

    // imageViewがprivateなのでSectionHeaderViewからアクセスするメソッドを作る
    func rotateImageView(sectionHeader: SectionHeader) {
        // animationが働いていない
        UIView.animate(withDuration: 10) {
            // 初期値はtrueで下向きであるべき
            if sectionHeader.isCellShowed {
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                self.imageView.transform = .identity
            }
        }
    }

}

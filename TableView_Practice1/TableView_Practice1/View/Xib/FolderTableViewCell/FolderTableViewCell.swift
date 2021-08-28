//
//  FoloerTableViewCell.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/28.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

    static let identifier = "FolderTableViewCell"
    static func nib() -> UINib {
        UINib(nibName: "FolderTableViewCell", bundle: nil)
    }

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var yearMonthLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator

        setupIconImageView()
    }

    private func setupIconImageView() {
        // 【設定】scale = large, weight = bold
        iconImageView.tintColor = UIColor(hex: "4169E1")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView = nil
        yearMonthLabel.text = nil
    }

    func configure(date: Date) {
        yearMonthLabel.text = String(date.year)+"."+String(date.month)
    }
    
}

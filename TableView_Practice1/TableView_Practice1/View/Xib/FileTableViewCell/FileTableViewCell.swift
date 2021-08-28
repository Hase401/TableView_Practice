//
//  FileTableViewCell.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/28.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    static let identifier = "FileTableViewCell"
    static func nib() -> UINib {
        UINib(nibName: "FileTableViewCell", bundle: nil)
    }

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!


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
        dateLabel.text = nil
    }

    func configure(today: Today) {
        dateLabel.text = String(today.month)+"/"+String(today.day)+" (\(today.week.name))"
    }
    
}

//
//  FileViewController.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/28.
//

import UIKit

class FileViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!

    // 【疑問】ここにModelをおく？
    var todays: [Today] = []

    // クロージャは渡す方向が逆
//    private var showTitleHandler: (String) -> Void = { _ in }
    // 単にinstatiateメソッドの引数で渡してあげればいい
    private var sectionDate: Date? // titleに使うだけ

    static func instantiate(sectionDate: Date) -> FileViewController {
        guard let vc = UIStoryboard(name: "SecondMyPage", bundle: nil).instantiateInitialViewController() as? FileViewController else {
            fatalError("FileViewControllerが見つかりません")
        }
        vc.sectionDate = sectionDate
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        self.navigationItem.largeTitleDisplayMode = .never

        // これをcellタップ時に渡したい！！
        self.navigationItem.title = String(sectionDate!.year)+"年"+String(sectionDate!.month)+"月"
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "doc.badge.gearshape"),
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapFixButton(_:)))
        rightButton.tintColor = UIColor(hex: "4169E1")
        self.navigationItem.rightBarButtonItem = rightButton

//        let myPageVC = MyPageViewController.instantiate()
//        // 【疑問】いつのdateArray?
//        print("dateArray: ", myPageVC.dateArray) // 何もなし // Modelのデータの統一をしたさ！！

        setupTableView()
    }

    private func setupTableView() {
        tableView.register(FileTableViewCell.nib(), forCellReuseIdentifier: FileTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        todays = [
            Today(month: self.sectionDate!.month, day: 10, week: WeekDay.sunday),
            Today(month: self.sectionDate!.month, day: 11, week: WeekDay.monday),
            Today(month: self.sectionDate!.month, day: 12, week: WeekDay.tuesday),
            Today(month: self.sectionDate!.month, day: 13, week: WeekDay.wednesday),
            Today(month: self.sectionDate!.month, day: 14, week: WeekDay.thursday),
            Today(month: self.sectionDate!.month, day: 15, week: WeekDay.friday),
            Today(month: self.sectionDate!.month, day: 16, week: WeekDay.saturday),
            Today(month: self.sectionDate!.month, day: 17, week: WeekDay.sunday),
            Today(month: self.sectionDate!.month, day: 18, week: WeekDay.monday)
        ]
    }

    @objc func didTapFixButton(_ sender: UIButton) {
        print("DidTapFixButton")
    }

}

extension FileViewController: UITableViewDelegate {

}

extension FileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fileCell = tableView.dequeueReusableCell(withIdentifier: FileTableViewCell.identifier, for: indexPath) as? FileTableViewCell else {
            fatalError("FileTableViewCellが返ってきてません")
        }
        fileCell.configure(today: todays[indexPath.row])
        return fileCell
    }

}

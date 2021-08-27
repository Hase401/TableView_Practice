//
//  MyDataViewController.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/23.
//

import UIKit

final class MyDataViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        self.navigationItem.title = "マイデータ"
        self.navigationController?.navigationBar.barTintColor = .blue
        let imageView = UIImageView(image: UIImage(systemName: "bell.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .green
        self.navigationItem.titleView = imageView
        let leftButton = UIBarButtonItem(title: "削除",
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapFixButton(_:)))
        leftButton.tintColor = .green
        self.navigationItem.leftBarButtonItem = leftButton
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: #selector(didTapFixButton(_:)))
        rightButton.tintColor = .red
        self.navigationItem.rightBarButtonItem = rightButton

        setupTableView()
        setupButton()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func setupButton() {
        button.backgroundColor = UIColor(hex: "4169E1")
        button.layer.cornerRadius = 32
    }

    // FAB
    // 【疑問】機能している？
//    var startingFrame : CGRect!
//    var endingFrame : CGRect!
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && self.button.isHidden {
//            self.button.isHidden = false
//            self.button.frame = startingFrame
//            UIView.animate(withDuration: 1.0) {
//                self.button.frame = self.endingFrame
//            }
//        }
//    }
//    func configureSizes() {
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
//
//        startingFrame = CGRect(x: 0, y: screenHeight+100, width: screenWidth, height: 100)
//        endingFrame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 100)
//    }
    

    static func instantiate() -> MyDataViewController {
        guard let vc = UIStoryboard(name: "FirstMyData", bundle: nil).instantiateInitialViewController() as? MyDataViewController else {
            fatalError("MyDataViewControllerが見つかりません")
        }
        return vc
    }

    @objc func didTapFixButton(_ sender: UIButton) {
        print("DidTapFixButton")
    }

    @IBAction func presentAlertTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Menu",
                                            message: "練習だよ",
                                            preferredStyle: UIAlertController.Style.actionSheet)
        let action1 = UIAlertAction(title: "今日",
                                    style: UIAlertAction.Style.default,
                                    handler: { (action: UIAlertAction!) in
            print("今日のルーティンを表示する処理")
        })
        let action2 = UIAlertAction(title: "明日",
                                    style: UIAlertAction.Style.default,
                                    handler: { (action: UIAlertAction!) in
            print("明日のルーティンを表示する処理")
        })
        let action3 = UIAlertAction(title: "昨日",
                                    style: UIAlertAction.Style.default,
                                    handler: { (action: UIAlertAction!) in
            print("昨日のルーティンを表示する処理")
        })
        let close = UIAlertAction(title: "閉じる",
                                  style: UIAlertAction.Style.destructive,
                                  handler: { (action: UIAlertAction!) in
            print("閉じる")
        })

        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(close)

        self.present(actionSheet, animated: true, completion: nil)
    }

}

extension MyDataViewController: UITableViewDelegate {

}

extension MyDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "日記"
    }
}

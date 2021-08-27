//
//  ViewController.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/23.
//

import UIKit

final class RecordViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var button: UIButton!

    var days = ["明日", "今日", "昨日"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationItem.title = "記録する"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let rightButton = UIBarButtonItem(title: "編集",
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapFixButton(_:)))
        self.navigationItem.rightBarButtonItem = rightButton

        setupTableView()
        setupButton()
//        setupPickerView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func setupButton() {
        button.layer.cornerRadius = 25
    }

    private func setupPickerView() {

    }

    static func instantiate() -> RecordViewController {
        guard let vc = UIStoryboard(name: "FirstRecord", bundle: nil).instantiateInitialViewController() as? RecordViewController else {
            fatalError("RecordViewControllerが見つかりません")
        }
        return vc
    }

    @objc func didTapFixButton(_ sender: UIButton) {
        print("DidTapFixButton")
    }
    
    @IBAction func showAlertTapped(_ sender: Any) {
        let title = "日にちを選択してください"
        let message = "\n\n\n\n\n\n\n\n" // pickerViewよりも広ければ一応問題なく動く
        let actionSheet = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: UIAlertController.Style.actionSheet)
        print("actionSheet.view.frame: ", actionSheet.view.frame)
        print("actionSheet.view.bounds: ", actionSheet.view.bounds)
        let pickerView = UIPickerView(frame: CGRect(x: 0,
                                                    y: 50,
                                                    width: actionSheet.view.bounds.width*0.955, // ここをプロパティを用いて設定したいが、、
                                                    height: 155)) // 合わせるのが面倒くさい。。。
//        pickerView.backgroundColor = .red
        pickerView.delegate = self
        pickerView.dataSource = self
        actionSheet.view.addSubview(pickerView)
        let ok = UIAlertAction(title: "OK",
                                    style: UIAlertAction.Style.default,
                                    handler: { (action: UIAlertAction!) in
            print("OK！画面遷移します！")
        })
        let close = UIAlertAction(title: "閉じる",
                                  style: UIAlertAction.Style.cancel,
                                  handler: { (action: UIAlertAction!) in
            print("閉じる")
        })
        actionSheet.addAction(ok)
        actionSheet.addAction(close)
        self.present(actionSheet, animated: true) {
            // 【疑問】actionSheetのframe.size.widthがpresent後に変化する？？？
//            pickerView.frame.size.width = actionSheet.view.frame.size.width
            print("actionSheet.view.frame: ", actionSheet.view.frame)
            print("actionSheet.view.bounds: ", actionSheet.view.bounds)
        }
    }

    // pickerViewで必須
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        days.count
    }

    // UIPickerViewで任意
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(days[row])
    }

}

extension RecordViewController: UITableViewDelegate {

}

extension RecordViewController: UITableViewDataSource {
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


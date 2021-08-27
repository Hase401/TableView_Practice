//
//  MyPageViewController.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/23.
//

import UIKit

final class MyPageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var semiBoldButton: UIButton!

    // 本来はstructでModelとして管理するべき
//    var year = "2021" // 初期値2021
//    var month = "1" // 初期値1
    var yearArray = [String]()
    var monthArray = [String]()
    //    var urudosi = [Bool]()
    var urudosi = [Int:Bool]() //閏年かどうかを格納する配列（年に対応）
    var files: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray
        self.navigationController?.navigationBar.barTintColor = .green
        self.navigationItem.title = "マイページ"

        setupData()
        setupTableView()
        setupButton()
    }

    func setupData() {
        for i in 2021...2050 {
            yearArray.append(String(i))
            //閏年かどうかの判断
            if i % 4 == 0 {
                if i % 100 == 0 {
                    if i % 400 == 0 {
//                        urudosi.append(true)
                        urudosi[i] = true
                    } else {
//                        urudosi.append(false)
                        urudosi[i] = false
                    }
                } else {
//                    urudosi.append(true)
                    urudosi[i] = true
                }
            } else {
//                urudosi.append(false)
                urudosi[i] = false
            }
        }
        for i in 1...12 {
            monthArray.append(String(i))
        }
//        print("yearArray: ", yearArray)
//        print("monthArray: ", monthArray)
        print("urudosi: ", urudosi)
//        print(urudosi[2100]) // false
        files = [yearArray, monthArray]
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func setupButton() {
        semiBoldButton.backgroundColor = UIColor(hex: "FFA500") // subColor
        semiBoldButton.layer.cornerRadius = 25
        // symbolScale = .large // storyboardで設定済み
    }
    
    static func instantiate() -> MyPageViewController {
        guard let vc = UIStoryboard(name: "FirstMyPage", bundle: nil).instantiateInitialViewController() as? MyPageViewController else {
            fatalError("MyPageViewControllerが見つかりません")
        }
        return vc
    }

    @IBAction func createFileTapped(_ sender: Any) {
        let title = "年月を選択してください"
        let message = "\n\n\n\n\n\n\n\n" // pickerViewよりも広ければ一応問題なく動く
        let actionSheet = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: UIAlertController.Style.actionSheet)
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
            print("OK！ファイルを追加します！")
        })
        let close = UIAlertAction(title: "閉じる",
                                  style: UIAlertAction.Style.cancel,
                                  handler: { (action: UIAlertAction!) in
            print("閉じる")
        })
        actionSheet.addAction(ok)
        actionSheet.addAction(close)
        self.present(actionSheet, animated: true) {

        }
    }

    // pickerViewで必須
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        files.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        files[component].count
    }

    // UIPickerViewで任意
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        files[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(files[component][row])
    }
}

extension MyPageViewController: UITableViewDelegate {

}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "年月"
    }
}

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
//    var year = "2021" // 初期値インストール日を代入する？
//    var month = "1" // 初期値インストール日を代入する？
    var yearArray = [Int]() // Int型のままPickerViewできる
    var monthArray = [Int]() // Int型のままPickerViewできる
    //    var urudosi = [Bool]()
    var urudosi = [Int:Bool]() // 閏年かどうかを格納する配列（年に対応）
    var componentFiles: [[Int]] = [] // 変更
//    let dayName = ["日", "月", "火", "水", "木", "金", "土"] // 曜日の配列
//    let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] // 各月の日数

    // アプリ全体のSectionを管理
    var yearFiles: [Int] = [] // sectionTitleに使う // Intに変更
//    // アプリ全体のフォルダを管理
//    var files: [String] = [] // 実際のtableViewで使う配列→Sectionごとの配列に変更したい // 辞書は順番としてSortできなそう
//    // アプリ全体のファイルを管理
//    var file: [String] = []
    // 【結論】section/folder/fileを1つの配列として実現したい→structかな？
    var dateArray: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "4169E1")
        self.navigationItem.title = "記録する"
        navigationController?.navigationBar.prefersLargeTitles = true

        setupArray()
        setupTableView()
        setupButton()
    }

    func setupArray() {
        for i in 2020...2050 {
            yearArray.append(i)
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
            monthArray.append(i)
        }
//        print("yearArray: ", yearArray)
//        print("monthArray: ", monthArray)
        print("urudosi: ", urudosi)
//        print(urudosi[2100]) // false
        componentFiles = [yearArray, monthArray]
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        yearFiles = [2020, 2021]
        yearFiles.sort {$0 > $1}
        dateArray = [
            Date(year: 2021, month: 5),
            Date(year: 2021, month: 4),
            Date(year: 2021, month: 3),
            Date(year: 2021, month: 2),
            Date(year: 2021, month: 1),
            Date(year: 2020, month: 12),
            Date(year: 2020, month: 11),
            Date(year: 2020, month: 10)
        ]
//        files = ["2021.8", "2021.7", "2021.6", "2021.5", "2021.4", "2021.3", "2021.2", "2020.12", "2020.11", "2020.10", "2020.9"]
    }

    private func setupButton() {
        semiBoldButton.backgroundColor = UIColor(hex: "FFA500") // subColor
        semiBoldButton.layer.cornerRadius = 25
        // symbolScale = .large // storyboardで設定済み
    }

//    // 曜日を計算する関数
//    func day(year: Int, month: Int, day: Int) -> Int {
//        var years = year
//        var monthes = month
//        if month == 1 || month == 2 {
//            years -= 1
//            monthes += 12
//        }
//        let halfUp = Int(years / 100)
//        let halfDown = years - halfUp * 100
//        let m = Int(((monthes + 1) * 26) / 10)
//        let y = Int(halfDown / 4)
//        let c = Int(halfUp / 4)
//        let h = (day + m + halfDown + y + c - 2 * halfUp) % 7
//        return h
//    }
    
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
        // cellに追加する（tableView.reloadData か configureメソッドを作る）
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertAction.Style.default,
                               handler: { (action: UIAlertAction!) in
                                print("OK！ファイルを追加します！")
                                let year = self.yearArray[pickerView.selectedRow(inComponent: 0)]
                                let month = self.monthArray[pickerView.selectedRow(inComponent: 1)]
                                var isYearCommon: Bool = false
                                for i in 0...self.yearFiles.count-1 {
                                    if year == self.yearFiles[i] {
                                        isYearCommon = true
                                    }
                                }
                                if !isYearCommon {
                                    self.yearFiles.append(year)
                                    self.yearFiles.sort {$0 > $1} // 降順
                                }
                                var isMonthCommon: Bool = false
                                for i in 0...self.dateArray.count-1 {
                                    if year == self.dateArray[i].year && month == self.dateArray[i].month {
                                        isMonthCommon = true
                                    }
                                }
                                if !isMonthCommon {
                                    self.dateArray.append(Date(year: year,month: month))
//                                    self.dateArray.sort {$0.year > $1.year}
                                    self.dateArray.sort {$0.month > $1.month}

                                }
                                self.tableView.reloadData()
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
        componentFiles.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        componentFiles[component].count
    }

    // UIPickerViewで任意
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(componentFiles[component][row]) // Stringに変更
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(componentFiles[component][row])
    }
}

extension MyPageViewController: UITableViewDelegate {

}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        files.count

        var count: Int = 0
        for i in 0...dateArray.count-1 {
            if yearFiles[section] == dateArray[i].year {
                count += 1
            }
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var array: [Date] = []
        for i in 0...dateArray.count-1 {
            if yearFiles[indexPath.section] == dateArray[i].year {
                array.append(dateArray[i])
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(array[indexPath.row].year)"+"."+"\(array[indexPath.row].month)"
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        yearFiles.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(yearFiles[section]) // String変に更
    }
}

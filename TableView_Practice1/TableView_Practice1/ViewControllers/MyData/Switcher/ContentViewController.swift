//
//  ContentViewController.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/30.
//

import UIKit

// 【修正】ContentViewDelegate → なし
final class ContentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var fruits: [String] = ["ばなな", "りんご", "みかん", "もも"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ContentViewController: UITableViewDelegate {
}

extension ContentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = fruits[indexPath.row]
        cell.backgroundColor = .green
        return cell
    }
}

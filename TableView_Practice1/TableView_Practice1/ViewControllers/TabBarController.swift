//
//  TabBarViewController.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/23.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTab()
    }

}

private extension TabBarController {
    func setupTab() {
        let recordVC = RecordViewController.instantiate()
        recordVC.tabBarItem = UITabBarItem(title: "記録する",
                                                    image: UIImage(systemName: "square.and.pencil"),
                                                    selectedImage: UIImage(systemName:"square.and.pencil"))
        let firstVC = UINavigationController(rootViewController: recordVC)
        let myDataVC = MyDataViewController.instantiate()
        myDataVC.tabBarItem = UITabBarItem(title: "マイデータ",
                                           image: UIImage(systemName: "paperclip"),
                                           selectedImage: UIImage(systemName: "paperclip"))
        let secondVC = UINavigationController(rootViewController: myDataVC)
        let myPageVC = MyPageViewController.instantiate()
        myPageVC.tabBarItem = UITabBarItem(title: "アカウント",
                                           image: UIImage(systemName: "person.fill"),
                                           selectedImage: UIImage(systemName: "person.fill"))
        let thirdVC = UINavigationController(rootViewController: myPageVC)
        self.viewControllers = [firstVC, secondVC, thirdVC]
    }
}

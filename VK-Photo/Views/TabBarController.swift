//
//  TabBarController.swift
//  VK-Photo
//
//  Created by Владимир on 10.04.2022.
//  Copyright © 2022 Владимир. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {
    let tabBarCnt = UITabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarCnt.tabBar.tintColor = UIColor.black
        createTabBarController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createTabBarController() {
        let firstVC = AllUsersViewController()
        firstVC.title = "Chats"
        firstVC.tabBarItem = UITabBarItem.init(title: "Users", image: UIImage(systemName: "person.crop.square"), tag: 0)
        
        let secondVC = ProfileViewController()
        secondVC.title = "Profile"
        secondVC.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage.init(systemName: "gear"), tag: 1)
        
        let vcArray = [firstVC, secondVC]
        tabBarCnt.viewControllers = vcArray.map{ UINavigationController.init(rootViewController: $0)}
        self.view.addSubview(tabBarCnt.view)
    }
}

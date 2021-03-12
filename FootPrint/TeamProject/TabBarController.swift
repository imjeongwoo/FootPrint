//
//  TabBarController.swift
//  TeamProject
//
//  Created by 임정우 on 2021/01/27.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }
        
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if selectedIndex == 0 {
            print("scroll top")
        } else if selectedIndex == 1 {
            print("scroll toptoptop")
        }
    }
}



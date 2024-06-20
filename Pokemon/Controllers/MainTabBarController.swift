//
//  MainTabBarController.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

enum MainTabEnum: Int {
    case Home = 0
}

class MainTabBarController: UITabBarController {
    let scale: CGFloat = UIFactory.getScale()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.isHidden = true
        
        let vc1 = createMainViewController(tabEnum: .Home)
        self.viewControllers = [vc1]
    }
    
    private func createMainViewController(tabEnum: MainTabEnum) -> UIViewController {
        let vc = HomeViewController()
        return vc
    }
}

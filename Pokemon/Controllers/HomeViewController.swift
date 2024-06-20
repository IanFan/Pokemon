//
//  HomeViewController.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    let scale: CGFloat = UIFactory.getScale()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.requestAPIs(isRefresh: false)
        }
    }
    
    func setupUI() {
        
    }
    
    func requestAPIs(isRefresh: Bool) {
        
    }
}

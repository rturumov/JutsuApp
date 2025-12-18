//
//  TabBarViewController.swift
//  Jutsu
//
//  Created by Rasul Turumov on 15.12.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
            super.viewDidLoad()
            setupAppearance()
        }

    private func setupAppearance() {
        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .gray
    }
}

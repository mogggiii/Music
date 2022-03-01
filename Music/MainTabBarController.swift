//
//  MainTabBarController.swift
//  Music
//
//  Created by mogggiii on 01.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.tintColor = Constant.Colors.tintColor
		
		viewControllers = [
			createNavigationController(
				viewController: SearchViewController(),
				title: "Search",
				image: "search",
				backgroundColor: .systemBackground),
			createNavigationController(
				viewController: LibraryViewController(),
				title: "Library",
				image: "library",
				backgroundColor: .systemBackground)]
	}
	
	fileprivate func createNavigationController(viewController: UIViewController,
																							title: String, image: String,
																							backgroundColor: UIColor) -> UIViewController {
		let navigationController = UINavigationController(rootViewController: viewController)
		navigationController.tabBarItem.title = title
		navigationController.tabBarItem.image = UIImage(named: image)
		navigationController.navigationBar.prefersLargeTitles = true
		
		viewController.view.backgroundColor = backgroundColor
		viewController.navigationItem.title = title
		
		return navigationController
	}
	
}

//
//  MainTabBarController.swift
//  Music
//
//  Created by mogggiii on 01.03.2022.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
	func minimaizeTrackDetailController() 
}

class MainTabBarController: UITabBarController {
	
	private var minimaizedTopAnchorConstraint: NSLayoutConstraint!
	private var maximaizedTopAnchorConstraint: NSLayoutConstraint!
	private var bottomAnchorConstraint: NSLayoutConstraint!
//	private var maximaizedTopAnchorConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.tintColor = Constant.Colors.tintColor
		
		setupTrackDetailView()
		
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
	
	fileprivate func setupTrackDetailView() {
		print("KEKEKEKEKEK")
		let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
		trackDetailView.tabBarDelegate = self
		trackDetailView.backgroundColor = .green
		view.insertSubview(trackDetailView, belowSubview: tabBar)
		
		//use autho layout
		trackDetailView.translatesAutoresizingMaskIntoConstraints = false
		
		maximaizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
		minimaizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
		bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
		
		bottomAnchorConstraint.isActive = true
		maximaizedTopAnchorConstraint.isActive = true
		trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//		trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
	
}

extension MainTabBarController: MainTabBarControllerDelegate {
	func minimaizeTrackDetailController() {
		
		maximaizedTopAnchorConstraint.isActive = false
		minimaizedTopAnchorConstraint.isActive = true
		
		UIView.animate(withDuration: 0.5,
									 delay: 0,
									 usingSpringWithDamping: 0.7,
									 initialSpringVelocity: 1,
									 options: .curveEaseOut,
									 animations: {
			self.view?.layoutIfNeeded()
		}, completion: nil)
	}
	
	
}

//
//  MainTabBarController.swift
//  Music
//
//  Created by mogggiii on 01.03.2022.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
	func minimaizeTrackDetailController()
	func maximaizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
	
	private var minimaizedTopAnchorConstraint: NSLayoutConstraint!
	private var maximaizedTopAnchorConstraint: NSLayoutConstraint!
	private var bottomAnchorConstraint: NSLayoutConstraint!
	let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
	var searchVC = SearchViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.tintColor = Constant.Colors.tintColor
		
		let library = Library()
		let hostVC = UIHostingController(rootView: library)
		hostVC.tabBarItem.image = UIImage(named: "library")
		hostVC.tabBarItem.title = "Library"
		
		viewControllers = [
			createNavigationController(
				viewController: searchVC,
				title: "Search",
				image: "search",
				backgroundColor: .systemBackground),
			hostVC
		]
		
		SearchViewController.tabBarDelegate = self
		Library.tabBarDelegate = self
		
		setupTrackDetailView()
	}
	
	// MARK: - Fileprivate func
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
		
		trackDetailView.tabBarDelegate = self
		trackDetailView.delegate = searchVC
		trackDetailView.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(trackDetailView, belowSubview: tabBar)
		
		// use autho layout
		maximaizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
		minimaizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
		bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
		
		bottomAnchorConstraint.isActive = true
		maximaizedTopAnchorConstraint.isActive = true
		
		trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}
	
}

// MARK: MainTabBarControllerDelegate
extension MainTabBarController: MainTabBarControllerDelegate {
	func maximaizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
		
		minimaizedTopAnchorConstraint.isActive = false
		maximaizedTopAnchorConstraint.isActive = true
		maximaizedTopAnchorConstraint.constant = 0
		bottomAnchorConstraint.constant = 0
		
		UIView.animate(withDuration: 0.5,
									 delay: 0,
									 usingSpringWithDamping: 0.7,
									 initialSpringVelocity: 1,
									 options: .curveEaseOut,
									 animations: {
			self.view?.layoutIfNeeded()
			self.tabBar.alpha = 0
			self.trackDetailView.miniPlayerView.alpha = 0
			self.trackDetailView.maximaizedStackView.alpha = 1
		}, completion: nil)
		
		guard let viewModel = viewModel else { return }
		self.trackDetailView.set(viewModel: viewModel)
	}
	
	func minimaizeTrackDetailController() {
		
		maximaizedTopAnchorConstraint.isActive = false
		bottomAnchorConstraint.constant = view.frame.height
		minimaizedTopAnchorConstraint.isActive = true
		
		UIView.animate(withDuration: 0.5,
									 delay: 0,
									 usingSpringWithDamping: 0.7,
									 initialSpringVelocity: 1,
									 options: .curveEaseOut,
									 animations: {
			self.view?.layoutIfNeeded()
			self.tabBar.alpha = 1
			self.trackDetailView.miniPlayerView.alpha = 1
			self.trackDetailView.maximaizedStackView.alpha = 0
		}, completion: nil)
	}
	
	
}

//
//  SearchViewController.swift
//  Music
//
//  Created by mogggiii on 02.03.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
	func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UITableViewController, SearchDisplayLogic {
	
	var interactor: SearchBusinessLogic?
	var router: (NSObjectProtocol & SearchRoutingLogic)?
	
	let searchController = UISearchController(searchResultsController: nil)
	private var trackViewModel = SearchViewModel.init(cells: [])
	private var timer: Timer?
	private lazy var footerView = FooterView()
	static var tabBarDelegate: MainTabBarControllerDelegate?
	var trackDetailVC: TrackDetailView = TrackDetailView.loadFromNib()
	
	
	static let reuseId = "cellId"
	
	// MARK: Object lifecycle
	
	
	// MARK: Setup
	
	private func setup() {
		let viewController        = self
		let interactor            = SearchInteractor()
		let presenter             = SearchPresenter()
		let router                = SearchRouter()
		viewController.interactor = interactor
		viewController.router     = router
		interactor.presenter      = presenter
		presenter.viewController  = viewController
		router.viewController     = viewController
	}
	
	// MARK: Routing
	
	
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		
		setupSearchBar()
		setupTableView()
		
		tableView.keyboardDismissMode = .onDrag
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let keyWindow = UIApplication.shared.connectedScenes
			.filter ({$0.activationState == .foregroundActive})
			.map ({$0 as? UIWindowScene})
			.compactMap ({$0})
			.first?.windows
			.filter({$0.isKeyWindow}).first
		let tabBarVC = keyWindow?.rootViewController as? MainTabBarController

		tabBarVC?.trackDetailView.delegate = self
	}
	
	func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
		switch viewModel {
		case .displayFooterView:
			footerView.showLoader()
		case .displayTracks(let trackViewModel):
			self.trackViewModel = trackViewModel
			tableView.reloadData()
			footerView.hideLoader()
		}
	}
	
	private func setupSearchBar() {
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
	}
	
	private func setupTableView() {
		tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchViewController.reuseId)
		tableView.tableFooterView = footerView
	}
	
	
	// MARK: - Table View Data Source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return trackViewModel.cells.count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 84
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.reuseId, for: indexPath) as! SearchTableViewCell
		let cellViewModel = trackViewModel.cells[indexPath.row]
		cell.set(viewModel: cellViewModel)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cellViewModel = trackViewModel.cells[indexPath.row]
		
		SearchViewController.tabBarDelegate?.maximaizeTrackDetailController(viewModel: cellViewModel)
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return trackViewModel.cells.count > 0 ? 0 : 250
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "Please enter search term above..."
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		return label
	}
	
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
			self.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
		})
	}
	
}

// MARK: TrackMovingDelegate
extension SearchViewController: TrackMovingDelegate {
	
	private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
		guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
		tableView.deselectRow(at: indexPath, animated: true)
		
		var nextIndexPath: IndexPath!
		
		if isForwardTrack {
			nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
			if nextIndexPath.row == trackViewModel.cells.count {
				nextIndexPath.row = 0
			}
		} else {
			nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
			if nextIndexPath.row == -1 {
				nextIndexPath.row = trackViewModel.cells.count - 1
			}
		}
		
		tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
		let cellViewModel = trackViewModel.cells[nextIndexPath.row]
		return cellViewModel
	}
	
	func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
		return getTrack(isForwardTrack: false)
	}
	
	func moveForwardForNextTrack() -> SearchViewModel.Cell? {
		return getTrack(isForwardTrack: true)
	}
	
	
}


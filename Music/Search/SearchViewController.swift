//
//  SearchViewController.swift
//  Music
//
//  Created by mogggiii on 02.03.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
	func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UITableViewController, SearchDisplayLogic {
	
	var interactor: SearchBusinessLogic?
	var router: (NSObjectProtocol & SearchRoutingLogic)?
	
	let searchController = UISearchController(searchResultsController: nil)
	private var trackViewModel = SearchViewModel.init(cell: [])
	private var timer: Timer?
	
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
		
	}
	
	func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
		switch viewModel {
		case .some:
			print("VC .some")
		case .displayTracks(let trackViewModel):
			print("presenter .presentTracks")
			self.trackViewModel = trackViewModel
			tableView.reloadData()
		}
	}
	
	private func setupSearchBar() {
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
	}
	
	private func setupTableView() {
		tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cellId")
	}
	
	
	// MARK: - Table View Data Source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return trackViewModel.cell.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
		let cellViewModel = trackViewModel.cell[indexPath.row]
		cell.track = cellViewModel
		return cell
	}
	
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print(searchText)
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
			self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchText: searchText))
		})
	}
	
}


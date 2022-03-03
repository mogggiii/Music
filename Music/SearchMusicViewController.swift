////
////  SearchViewController.swift
////  Music
////
////  Created by mogggiii on 01.03.2022.
////
//
//import UIKit
//
//class SearchMusicViewController: UITableViewController {
//	
//	private var timer: Timer?
//	let searchController = UISearchController(searchResultsController: nil)
//	var tracks = [Track]()
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		setupSearchBar()
//		
//		tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cellId")
//		
//	}
//	
//	private func setupSearchBar() {
//		navigationItem.searchController = searchController
//		navigationItem.hidesSearchBarWhenScrolling = false
//		searchController.searchBar.delegate = self
//	}
//	
//	// MARK: - Table view data source
//	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return tracks.count
//		
//	}
//	
//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
//		let track = tracks[indexPath.row]
//		cell.track = track
//		return cell
//	}
//	
//}
//
//// MARK: - Search Bar Delegate
//extension SearchMusicViewController: UISearchBarDelegate {
//	
//	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		
//		timer?.invalidate()
//		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
//			NetworkManager.shared.fetchTracks(searchText: searchText) { [weak self] tracks in
//				guard let tracks = tracks else { return }
//				self?.tracks = tracks
//				self?.tableView.reloadData()
//			}
//		})
//	}
//}

//
//  SearchPresenter.swift
//  Music
//
//  Created by mogggiii on 02.03.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
		switch response {
		case .some:
			print("Presenter .some")
		case .presentTracks(let searchResult):
			guard let searchResult = searchResult else { break }
			let cells = searchResult.map { track in
				cellViewModel(from: track)
			}
			
			let trackViewModel = SearchViewModel.init(cell: cells)
			print("Presenter .presentTracks")
			viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayTracks(trackViewModel: trackViewModel))
		}
  }
  
	private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
		return SearchViewModel.Cell.init(iconUrlString: track.artworkUrl100,
																		trackName: track.trackName,
																		collectionName: track.collectionName ?? "",
																		artistName: track.artistName)
	}
}

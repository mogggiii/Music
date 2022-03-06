//
//  SearchInteractor.swift
//  Music
//
//  Created by mogggiii on 02.03.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
	func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
	
	var networkManager = NetworkManager()
	var presenter: SearchPresentationLogic?
	var service: SearchService?
	
	func makeRequest(request: Search.Model.Request.RequestType) {
		if service == nil {
			service = SearchService()
		}
		switch request {
		case .getTracks(let searchText):
			print("Interactor search Text", searchText)
			print("Interactor .getTracks")
			presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
			
			networkManager.fetchTracks(searchTerm: searchText) { [weak self] (searchResponse) in
				self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
			}
		}
	}
	
}

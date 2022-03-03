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

  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
			switch request {
			case .some:
				print("Interactor .some")
			case .getTracks(let searchText):
				print("Interactor .getTracks")
				NetworkManager.shared.fetchTracks(searchText: searchText) { [weak self] searchResponse in
					self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
				}
			}
    }
  }
  
}

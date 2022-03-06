//
//  SearchModels.swift
//  Music
//
//  Created by mogggiii on 02.03.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
				case getTracks(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
				case presentTracks(searchResponse: SearchResponse?)
				case presentFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
				case displayTracks(trackViewModel: SearchViewModel)
				case displayFooterView
      }
    }
  }
}

struct SearchViewModel {
	struct Cell: TrackCellViewModel {
		var iconUrlString: String?
		var trackName: String
		var collectionName: String?
		var artistName: String
		var previewUrl: String? 
	}
	
	var cell: [Cell]
}


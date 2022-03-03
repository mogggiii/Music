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
        case some
				case getTracks(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
				case presentTracks(searchResponse: [Track]?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
				case displayTracks(trackViewModel: SearchViewModel)
      }
    }
  }
}

struct SearchViewModel {
	struct Cell {
		var iconUrlString: String?
		var trackName: String
		var collectionName: String?
		var artistName: String
	}
	
	let cell: [Cell]
}


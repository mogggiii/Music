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

class SearchViewModel: NSObject, NSCoding {
	
	@objc(_TtCC5Music15SearchViewModel4Cell)class Cell: NSObject, NSCoding {
		
		var iconUrlString: String?
		var trackName: String
		var collectionName: String?
		var artistName: String
		var previewUrl: String?
		
		init(iconUrlString: String?, trackName: String, collectionName: String?, artistName: String, previewUrl: String?) {
			self.iconUrlString = iconUrlString
			self.trackName = trackName
			self.collectionName = collectionName
			self.artistName = artistName
			self.previewUrl = previewUrl
		}
		
		required init?(coder: NSCoder) {
			iconUrlString = coder.decodeObject(forKey: "iconUrlString") as? String? ?? ""
			trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
			collectionName = coder.decodeObject(forKey: "collectionName") as? String? ?? ""
			artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
			previewUrl = coder.decodeObject(forKey: "previewUrl") as? String? ?? ""
		}
		
		func encode(with coder: NSCoder) {
			coder.encode(iconUrlString, forKey: "iconUrlString")
			coder.encode(trackName, forKey: "trackName")
			coder.encode(collectionName, forKey: "collectionName")
			coder.encode(artistName, forKey: "artistName")
			coder.encode(previewUrl, forKey: "previewUrl")
		}
	}
	
	let cells: [Cell]
	
	init(cells: [Cell]) {
		self.cells = cells
	}
	
	required init?(coder: NSCoder) {
		cells = coder.decodeObject(forKey: "cells") as? [SearchViewModel.Cell] ?? []
	}
	
	func encode(with coder: NSCoder) {
		coder.encode(cells, forKey: "cells")
	}
	
	
	
	
}


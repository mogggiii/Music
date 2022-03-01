//
//  TrackModel.swift
//  Music
//
//  Created by mogggiii on 01.03.2022.
//

import Foundation

struct TrackModel: Decodable {
	var resultsCount: Int?
	var results: [Track]
}

struct Track: Decodable {
	var trackName: String
	var collectionName: String?
	var artistName: String
	var artworkUrl100: String?
}

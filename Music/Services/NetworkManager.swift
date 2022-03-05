//
//  NetworkManager.swift
//  Music
//
//  Created by mogggiii on 01.03.2022.
//

import Foundation
import Alamofire

final class NetworkManager {
	
	static let shared = NetworkManager()
	
	func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> ()) {
		let url = "https://itunes.apple.com/search?"
		let parameters = ["term":" \(searchText)",
											"limit": "60",
											"media": "music"]
		AF.request(url, method: .get, parameters: parameters, encoder: .urlEncodedForm, headers: nil).responseDecodable(of: SearchResponse.self) { response in
			switch response.result {
			case .success(let data):
				print(data.results.count)
				completion(data)
			case .failure(let error):
				print(error.localizedDescription)
				completion(nil)
			}
		}
	}
}

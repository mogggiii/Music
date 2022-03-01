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
	
	public func response(url: String, parametres: [String: String], completion: @escaping ([Track]?, Error?) -> ()) {
		AF.request(url, method: .get, parameters: parametres, encoder: .urlEncodedForm, headers: nil).responseDecodable(of: TrackModel.self) { response in
			switch response.result {
			case .success(let data):
				print(data.results.count)
				completion(data.results, nil)
			case .failure(let error):
				print(error.localizedDescription)
				completion(nil, error)
			}
		}
	}
}

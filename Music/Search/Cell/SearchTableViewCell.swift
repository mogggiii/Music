//
//  SearchTableViewCell.swift
//  Music
//
//  Created by mogggiii on 01.03.2022.
//

import UIKit
import SDWebImage

// MARK: - TrackCellViewModel
//protocol TrackCellViewModel {
//	var artistName: String { get }
//	var trackName: String { get }
//	var collectionName: String? { get }
//	var iconUrlString: String? { get }
//}

class SearchTableViewCell: UITableViewCell {
	
	var cell: SearchViewModel.Cell?
	
	// MARK: - UI Elements
	var trackName: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17)
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var artistName: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .medium)
		label.textColor = UIColor(red: 184 / 255, green: 184 / 255, blue: 186 / 255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var collectionName: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13)
		label.textColor = .gray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var albumCover: UIImageView = {
		let cover = UIImageView()
		cover.layer.cornerRadius = 7
		cover.clipsToBounds = true
		cover.translatesAutoresizingMaskIntoConstraints = false
		return cover
	}()
	
	let addButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "add"), for: .normal)
		button.addTarget(self, action: #selector(addTrackAction), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureCell()
		albumCover.image = nil
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Set Cell via ViewModel
	func set(viewModel: SearchViewModel.Cell) {
		
		self.cell = viewModel
		
		let savedTracks = UserDefaults.standard.savedTracks()
		let hasFavorite = savedTracks.firstIndex {
			$0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
		} != nil
		
		if hasFavorite {
			addButton.isHidden = true
		} else {
			addButton.isHidden = false
		}
		
		artistName.text = viewModel.artistName
		trackName.text = viewModel.trackName
		collectionName.text = viewModel.collectionName ?? ""
		
		guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
		albumCover.sd_setImage(with: url, completed: nil)
	}
	
	// MARK: - Save track (User Defaults)
	@objc func addTrackAction() {
		let defaults = UserDefaults.standard
		guard let cell = cell else { return }
		var listOfTracks = defaults.savedTracks()
		addButton.isHidden = true
	
		listOfTracks.append(cell)
		
		if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
			print("Succes")
			defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
		}
	}
	
	// MARK: - Configure Cell
	fileprivate func configureCell() {
		
		contentView.addSubview(artistName)
		contentView.addSubview(trackName)
		contentView.addSubview(collectionName)
		contentView.addSubview(albumCover)
		contentView.addSubview(addButton)
		
		NSLayoutConstraint.activate([
			
			albumCover.widthAnchor.constraint(equalToConstant: 60),
			albumCover.heightAnchor.constraint(equalToConstant: 60),
			albumCover.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
			albumCover.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
			albumCover.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 21),
			
			trackName.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13),
			trackName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 9),
			trackName.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -14),
			
			artistName.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: 2),
			artistName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 9),
			artistName.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -14),
			
			collectionName.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 3),
			collectionName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 9),
			collectionName.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -14),
			
			addButton.heightAnchor.constraint(equalToConstant: 20),
			addButton.widthAnchor.constraint(equalToConstant: 20),
			addButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 34),
			addButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -34),
			addButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
			
		])
	}
	
}

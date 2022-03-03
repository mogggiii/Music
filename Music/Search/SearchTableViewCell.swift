//
//  SearchTableViewCell.swift
//  Music
//
//  Created by mogggiii on 01.03.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

	var track: SearchViewModel.Cell? {
		didSet {
			guard let track = track else { return }
			artistName.text = track.artistName
			trackName.text = track.trackName
			collectionName.text = track.collectionName ?? ""
		}
	}
	
	let trackName: UILabel = {
		let label = UILabel()
		label.text = "oo"
		label.font = .systemFont(ofSize: 17)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let artistName: UILabel = {
		let label = UILabel()
		label.text = "oo"
		label.font = .systemFont(ofSize: 13)
		label.textColor = .gray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let collectionName: UILabel = {
		let label = UILabel()
		label.text = "oo"
		label.font = .systemFont(ofSize: 13)
		label.textColor = .gray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let albumCover: UIImageView = {
		let cover = UIImageView()
		cover.image = UIImage(named: "cover")
		cover.layer.cornerRadius = 7
		cover.clipsToBounds = true
		cover.translatesAutoresizingMaskIntoConstraints = false
		return cover
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureCell()
	}
	
	fileprivate func configureCell() {
		
		contentView.addSubview(artistName)
		contentView.addSubview(trackName)
		contentView.addSubview(collectionName)
		contentView.addSubview(albumCover)
		
		NSLayoutConstraint.activate([
			
			albumCover.widthAnchor.constraint(equalToConstant: 61),
			albumCover.heightAnchor.constraint(equalToConstant: 61),
			albumCover.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
			albumCover.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
			albumCover.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
			
			trackName.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
			trackName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 16),
			trackName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			
			artistName.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: 5),
			artistName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 16),
			artistName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			
			collectionName.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 5),
			collectionName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 16),
			collectionName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
		
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//
//  FooterView.swift
//  Music
//
//  Created by mogggiii on 05.03.2022.
//

import UIKit

class FooterView: UIView {
	
	private var label: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		return label
	}()
	
	private var loader: UIActivityIndicatorView = {
		let loader = UIActivityIndicatorView()
		loader.hidesWhenStopped = true
		loader.translatesAutoresizingMaskIntoConstraints = false
		return loader
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public Methods
	func showLoader() {
		loader.startAnimating()
		label.text = "LOADING"
	}
	
	func hideLoader() {
		loader.stopAnimating()
		label.text = ""
	}
	
	// MARK: - Private Methods
	private func setupView() {
		addSubview(label)
		addSubview(loader)
		
		NSLayoutConstraint.activate([
			loader.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
		
			label.centerXAnchor.constraint(equalTo: centerXAnchor),
			label.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8)
		])
	}
	
}

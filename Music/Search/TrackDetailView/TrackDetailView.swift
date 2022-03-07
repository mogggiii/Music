//
//  TrackDetailView.swift
//  Music
//
//  Created by mogggiii on 06.03.2022.
//

import UIKit
import AVKit


class TrackDetailView: UIView {
	
	// MARK: - IBOutlets
	@IBOutlet weak var trackImageView: UIImageView!
	@IBOutlet weak var currentTimeSlider: UISlider!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	@IBOutlet weak var trackTitleLabel: UILabel!
	@IBOutlet weak var authorTitleLabel: UILabel!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var volumeSlider: UISlider!
	
	let player: AVPlayer = {
		let avPlayer = AVPlayer()
		avPlayer.automaticallyWaitsToMinimizeStalling = false
		return avPlayer
	}()
	
	// MARK: - awakeFromNib
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let scale: CGFloat = 0.8
		trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
		trackImageView.layer.cornerRadius = 5
	}
	
	// MARK: - Setup
	func set(viewModel: SearchViewModel.Cell) {
		
		let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
		guard let url = URL(string: string600 ?? "") else { return }
		
		trackTitleLabel.text = viewModel.trackName
		authorTitleLabel.text = viewModel.artistName
		trackImageView.sd_setImage(with: url, completed: nil)
		
		playTrack(previewUrl: viewModel.previewUrl)
		
		monitorStartTime()
	}
	
	// MARK: - Private Methods
	private func playTrack(previewUrl: String?) {
		guard let url = URL(string: previewUrl ?? "") else { return }
		
		let playerItem = AVPlayerItem(url: url)
		player.replaceCurrentItem(with: playerItem)
		player.play()
	}
	
	// MARK: - Animations
	private func enlargeTrackImageView() {
		UIView.animate(withDuration: 1.0,
									 delay: 0,
									 usingSpringWithDamping: 0.5,
									 initialSpringVelocity: 1,
									 options: .curveEaseOut,
									 animations: {
			self.trackImageView.transform = .identity
		}, completion: nil)
	}
	
	private func reduceTrackImageView() {
		UIView.animate(withDuration: 1.0,
									 delay: 0,
									 usingSpringWithDamping: 0.5,
									 initialSpringVelocity: 1,
									 options: .curveEaseOut,
									 animations: {
			let scale: CGFloat = 0.8
			self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
		}, completion: nil)
	}
	
	// MARK: - Time setup
	private func monitorStartTime() {
		let time = CMTimeMake(value: 1, timescale: 3)
		let times = [NSValue(time: time)]
		player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
			self?.enlargeTrackImageView()
		}
	}
	
	// MARK: - IBActions
	@IBAction func dragDownButtonTapped(_ sender: Any) {
		self.removeFromSuperview()
	}
	
	@IBAction func handleCurrentTimeSlider(_ sender: Any) {
	}
	
	@IBAction func handleVolumeSlider(_ sender: Any) {
	}
	
	@IBAction func previousTrack(_ sender: Any) {
	}
	
	@IBAction func nextTrack(_ sender: Any) {
	}
	
	// Play Pause actiions
	@IBAction func playPauseAction(_ sender: Any) {
		if player.timeControlStatus == .paused {
			player.play()
			playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
			enlargeTrackImageView()
		} else {
			player.pause()
			playPauseButton.setImage(UIImage(named: "play"), for: .normal)
			reduceTrackImageView()
		}
	}
}
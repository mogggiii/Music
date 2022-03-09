//
//  TrackDetailView.swift
//  Music
//
//  Created by mogggiii on 06.03.2022.
//

import UIKit
import AVKit

protocol TrackMovingDelegate: class {
	func moveBackForPreviousTrack() -> SearchViewModel.Cell?
	func moveForwardForNextTrack() -> SearchViewModel.Cell?
}

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
	
	weak var delegate: TrackMovingDelegate?
	
	// MARK: - awakeFromNib
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let scale: CGFloat = 0.8
		trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
		trackImageView.layer.cornerRadius = 6
		
		currentTimeSlider.setThumbImage(UIImage(named: "knob2"), for: .normal)
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
		observePlayerCurrentTime()
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
	
	private func observePlayerCurrentTime() {
		let interval = CMTimeMake(value: 1, timescale: 2)
		player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
			self?.currentTimeLabel.text = time.toDisplayString()
			
			// Duration playing track time
			let durationTime = self?.player.currentItem?.duration
			let currentDurationTimeText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
			self?.durationLabel.text = "-\(currentDurationTimeText)"
			self?.updateCurrentTimeSlider()
		}
	}
	
	private func updateCurrentTimeSlider() {
		let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
		let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
		let percentage = currentTimeSeconds / durationSeconds
		self.currentTimeSlider.value = Float(percentage)
	}
	
	// MARK: - IBActions
	@IBAction func dragDownButtonTapped(_ sender: Any) {
		self.removeFromSuperview()
	}
	
	// Player Slider
	@IBAction func handleCurrentTimeSlider(_ sender: Any) {
		guard let duration = player.currentItem?.duration else { return }
		
		let percentage = currentTimeSlider.value
		let durationInSeconds = CMTimeGetSeconds(duration)
		let seekTimeInSeconds = Float64(percentage) * durationInSeconds
		let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
		
		player.seek(to: seekTime)
	}
	
	// Volume slider
	@IBAction func handleVolumeSlider(_ sender: Any) {
		player.volume = volumeSlider.value
	}
	
	@IBAction func previousTrack(_ sender: Any) {
		let cellViewModel = delegate?.moveBackForPreviousTrack()
		guard let cellInfo = cellViewModel else { return }
		self.set(viewModel: cellInfo)
	}
	
	@IBAction func nextTrack(_ sender: Any) {
		let cellViewModel = delegate?.moveForwardForNextTrack()
		guard let cellInfo = cellViewModel else { return }
		self.set(viewModel: cellInfo)
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

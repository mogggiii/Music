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
	@IBOutlet weak var miniPlayerView: UIView!
	@IBOutlet weak var miniGoForwardButton: UIButton!
	@IBOutlet weak var miniTrackImageView: UIImageView!
	@IBOutlet weak var miniTrackTitleLabel: UILabel!
	@IBOutlet weak var miniPlayerPlayButton: UIButton!
	
	@IBOutlet weak var maximaizedStackView: UIStackView!
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
	
	static var delegate: TrackMovingDelegate?
	weak var tabBarDelegate: MainTabBarControllerDelegate?
	
	// MARK: - awakeFromNib
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let scale: CGFloat = 0.8
		trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
		trackImageView.layer.cornerRadius = 6
		
		miniPlayerPlayButton.tintColor = .black
		playPauseButton.tintColor = .black
		
		currentTimeSlider.setThumbImage(UIImage(named: "knob2"), for: .normal)
	}
	
	// MARK: - Setup
	func set(viewModel: SearchViewModel.Cell) {
		
		let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
		let string60 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "60x60")
		
		guard
			let url = URL(string: string600 ?? ""),
			let url60 = URL(string: string60 ?? "")
		else { return }
		
		miniTrackTitleLabel.text = viewModel.trackName
		trackTitleLabel.text = viewModel.trackName
		authorTitleLabel.text = viewModel.artistName
		trackImageView.sd_setImage(with: url, completed: nil)
		miniTrackImageView.sd_setImage(with: url60, completed: nil)
		playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
		miniPlayerPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
		
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
		self.tabBarDelegate?.minimaizeTrackDetailController()
//		self.removeFromSuperview()
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
		let cellViewModel = TrackDetailView.delegate?.moveBackForPreviousTrack()
		guard let cellInfo = cellViewModel else { return }
		self.set(viewModel: cellInfo)
	}
	
	@IBAction func nextTrack(_ sender: Any) {
		let cellViewModel = TrackDetailView.delegate?.moveForwardForNextTrack()
		guard let cellInfo = cellViewModel else { return }
		self.set(viewModel: cellInfo)
	}
	
	// Play Pause actiions
	@IBAction func playPauseAction(_ sender: Any) {
		if player.timeControlStatus == .paused {
			player.play()
			playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
			miniPlayerPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
			enlargeTrackImageView()
		} else {
			player.pause()
			playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
			miniPlayerPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
			reduceTrackImageView()
		}
	}
}

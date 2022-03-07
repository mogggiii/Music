//
//  TrackDetailView.swift
//  Music
//
//  Created by mogggiii on 06.03.2022.
//

import UIKit
import AVFAudio


class TrackDetailView: UIView {
	
	@IBOutlet weak var trackImageView: UIImageView!
	@IBOutlet weak var currentTimeSlider: UISlider!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	@IBOutlet weak var trackTitleLabel: UILabel!
	@IBOutlet weak var authorTitleLabel: UILabel!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var volumeSlider: UISlider!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		trackImageView.backgroundColor = .red
	}
	
	
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
	
	@IBAction func playPauseAction(_ sender: Any) {
	}
}

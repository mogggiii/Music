//
//  Library.swift
//  Music
//
//  Created by mogggiii on 14.03.2022.
//

import SwiftUI

struct Library: View {
	
	@State var tracks = UserDefaults.standard.savedTracks()
	@State var showingAlert = false
	@State private var track: SearchViewModel.Cell!
	
	static var tabBarDelegate: MainTabBarControllerDelegate?
	
	var body: some View {
		NavigationView {
			VStack {
				GeometryReader { geometry in
					HStack(spacing: 20) {
						Button {
							self.track = self.tracks[0]
							Library.tabBarDelegate?.maximaizeTrackDetailController(viewModel: self.track)
						} label: {
							Image(systemName: "play.fill")
								.frame(width: geometry.size.width / 2 - 10, height: 50)
								.tint(Color(red: 253 / 255, green: 45 / 255, blue: 85 / 255))
								.background(Color(red: 229 / 255, green: 231 / 255, blue: 231 / 255))
								.cornerRadius(10)
						}
						Button {
							self.tracks = UserDefaults.standard.savedTracks()
						} label: {
							Image(systemName: "arrow.triangle.2.circlepath")
								.frame(width: geometry.size.width / 2 - 10, height: 50)
								.tint(Color(red: 253 / 255, green: 45 / 255, blue: 85 / 255))
								.background(Color(red: 229 / 255, green: 231 / 255, blue: 231 / 255))
								.cornerRadius(10)
						}
					}
				}.padding().frame(height: 50)
				Divider().padding(.top)
				
				// MARK: - List of Tracks
				List {
					ForEach(tracks) { track in
						LibraryCell(cell: track).gesture(
							LongPressGesture()
								.onEnded { _ in
									print("Pressed")
									self.track = track
									self.showingAlert = true
								}
								.simultaneously(with: TapGesture().onEnded { _ in
									
									let keyWindow = UIApplication.shared.connectedScenes
										.filter ({$0.activationState == .foregroundActive})
										.map ({$0 as? UIWindowScene})
										.compactMap ({$0})
										.first?.windows
										.filter({$0.isKeyWindow}).first
									let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
									tabBarVC?.trackDetailView.delegate = self
									
									self.track = track
									Library.tabBarDelegate?.maximaizeTrackDetailController(viewModel: self.track)
								}))
					} .onDelete(perform: delete)
				} .listStyle(.plain)
					.listRowSeparator(.hidden)
				
			}.actionSheet(isPresented: $showingAlert, content: {
				ActionSheet( title: Text("Are you sure you want to delete this track?"), buttons: [.destructive(Text("Delete"), action: {
					self.delete(track: self.track)
				}), .cancel()])
			})
				.navigationBarTitle("Library")
		}
		
	}
	
	// MARK: - Delete Functions
	func delete(at offset: IndexSet) {
		tracks.remove(atOffsets: offset)
		if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
		}
	}
	
	func delete(track: SearchViewModel.Cell) {
		let index = tracks.firstIndex(of: track)
		guard let index = index else { return }
		tracks.remove(at: index)
		
		if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
		}
	}
}

struct Library_Previews: PreviewProvider {
	static var previews: some View {
		Library()
	}
}

extension Library: TrackMovingDelegate {
	func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
		let index = tracks.firstIndex(of: track)
		guard let index = index else { return nil }
		var previosTrack: SearchViewModel.Cell
		
		if index - 1 == -1 {
			previosTrack = tracks[tracks.count - 1]
		} else {
			previosTrack = tracks[index - 1]
		}
		
		self.track = previosTrack
		return previosTrack
	}
	
	func moveForwardForNextTrack() -> SearchViewModel.Cell? {
		let index = tracks.firstIndex(of: track)
		guard let index = index else { return nil }
		var nextTrack: SearchViewModel.Cell
		
		if index + 1 == tracks.count {
			nextTrack = tracks[0]
		} else {
			nextTrack = tracks[index + 1]
		}
		
		self.track = nextTrack
		return nextTrack
	}
	
	
}


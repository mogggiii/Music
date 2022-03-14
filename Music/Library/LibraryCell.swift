//
//  LibraryCell.swift
//  Music
//
//  Created by mogggiii on 14.03.2022.
//

import SwiftUI

struct LibraryCell: View {
	var body: some View {
		HStack() {
			Image("cover")
				.resizable()
				.cornerRadius(5)
				.frame(width: 60, height: 60)
			VStack {
				Text("Track Name")
				Text("Artist Name")
			}
		}
		
	}
}

struct LibraryCell_Previews: PreviewProvider {
	static var previews: some View {
		LibraryCell()
	}
}

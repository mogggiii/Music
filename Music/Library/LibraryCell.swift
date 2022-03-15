//
//  LibraryCell.swift
//  Music
//
//  Created by mogggiii on 14.03.2022.
//

import SwiftUI
import URLImage

struct LibraryCell: View {
	
	var cell: SearchViewModel.Cell
	
	var body: some View {
		HStack() {
			URLImage(URL(string: cell.iconUrlString ?? "")!, identifier: nil) { image in
				image.resizable()
					.cornerRadius(5)
					.frame(width: 60, height: 60)
			}
			
			VStack(alignment: .leading) {
				Text(cell.trackName)
				Text(cell.artistName)
			}
		}
		
	}
}

//struct LibraryCell_Previews: PreviewProvider {
//	static var previews: some View {
//		LibraryCell(cell: cell)
//	}
//}

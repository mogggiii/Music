//
//  Library.swift
//  Music
//
//  Created by mogggiii on 14.03.2022.
//

import SwiftUI

struct Library: View {
	var body: some View {
		NavigationView {
			VStack {
				GeometryReader { geometry in
					HStack(spacing: 20) {
						Button {
							print("1234")
						} label: {
							Image(systemName: "play.fill")
								.frame(width: geometry.size.width / 2 - 10, height: 50)
								.tint(Color(red: 253 / 255, green: 45 / 255, blue: 85 / 255))
								.background(Color(red: 229 / 255, green: 231 / 255, blue: 231 / 255))
								.cornerRadius(10)
						}
						Button {
							print("59090")
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
				List {
					LibraryCell()
					Text("First")
					Text("First")
				} .listStyle(.plain)
					.listRowSeparator(.hidden)

			}
			
			.navigationBarTitle("Library")
		}
		
	}
}

struct Library_Previews: PreviewProvider {
	static var previews: some View {
		Library()
	}
}

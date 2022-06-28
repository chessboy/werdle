//
//  KeyboardView.swift
//  Werdle
//
//  Created by Rob Silverman on 6/26/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct KeyboardView: View {
	
	@Binding var game: Game
	var width: CGFloat

	init(game: Binding<Game>, width: CGFloat) {
		self.width = width
		self._game = game
	}

	var body: some View {
		
		GeometryReader { geo in
			VStack(alignment: .center, spacing: 7) {

				HStack(alignment: .center, spacing: 5) {
					
					Spacer()
					ForEach(Constants.Keyboard.row1, id: \.self) { text in
						Button(action: {
							game.acceptKey(text)
						}) {
							
							ZStack {

								Rectangle().foregroundColor(game.colorForKeyboardLetter(text))
									.frame(width: width/12, height: width/9, alignment: .center)
									.cornerRadius(6)
								
									Text(text)
										.appFont(.black, size: 15)
										.foregroundColor(.white)
							}

						}.buttonStyle(ScaleButtonStyle())

					}
					Spacer()
				}
				
				HStack(alignment: .center, spacing: 5) {
					Spacer()
					ForEach(Constants.Keyboard.row2, id: \.self) { text in
						
						Button(action: {
							game.acceptKey(text)
						}) {
							
							ZStack {

								Rectangle().foregroundColor(game.colorForKeyboardLetter(text))
									.frame(width: width/12, height: width/9, alignment: .center)
									.cornerRadius(6)
								
									Text(text)
										.appFont(.black, size: 15)
										.foregroundColor(.white)
							}

						}.buttonStyle(ScaleButtonStyle())
					}
					Spacer()
				}
				
				HStack(alignment: .center, spacing: 5) {
					Spacer()
					ForEach(Constants.Keyboard.row3, id: \.self) { text in
							
						Button(action: {
							game.acceptKey(text)
						}) {
							
							ZStack {

								Rectangle().foregroundColor(game.colorForKeyboardLetter(text))
									.frame(width: text == "ENTER" ? width/7 : width/12, height: width/9, alignment: .center)
									.cornerRadius(6)
								
									Text(text)
										.appFont(.black, size: 15)
										.foregroundColor(.white)
							}

						}.buttonStyle(ScaleButtonStyle())
					}
					Spacer()
				}
			}
		}
	}
}

struct KeyboardView_Previews: PreviewProvider {
	static var previews: some View {
		PreviewWrapper()
	}

	struct PreviewWrapper: View {

		@State(initialValue: Game()) var game: Game

		var body: some View {
			GeometryReader { geo in
				
				VStack {
					Spacer()
					KeyboardView(game: self.$game, width: min(geo.size.width, geo.size.height))
						.frame(width: min(geo.size.width, geo.size.height))
						.frame(height: min(geo.size.width, geo.size.height))
						.preferredColorScheme(.dark)
					Spacer()
				}
			}
		}
	}
}

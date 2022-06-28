//
//  SqaureView.swift
//  Werdle
//
//  Created by Robert Silverman on 4/5/20.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct SquareView: View {
	
	var width: CGFloat
	var columns: [GridItem] = []
	@Binding var game: Game

	init(game: Binding<Game>, width: CGFloat) {
		self.width = width
		self._game = game
    }
	
	var body: some View {
		
		VStack {
			ForEach(game.wordGuesses, id: \.id) { wordGuess in
				HStack {
					ForEach(wordGuess.letterGuesses, id: \.id) { letterGuess in
						
						ZStack {
							Rectangle().foregroundColor(wordGuess.bad ? Colors.squareBadWord : letterGuess.eval.color).border(wordGuess.bad ? Colors.squareBadWord : letterGuess.eval.borderColor, width: 2)
								.frame(width: width/6, height: width/6, alignment: .center)
							Text(letterGuess.letter)
								.appFont(.black, size: 45)
								.foregroundColor(.white)
						}
					}
				}
			}
			.padding(.horizontal)
		}
	}
}

struct SquareView_Previews: PreviewProvider {
	static var previews: some View {
		PreviewWrapper()
	}

	struct PreviewWrapper: View {

		@State(initialValue: Game()) var game: Game

		var body: some View {
			GeometryReader { geo in
				
				VStack {
					Spacer()
					SquareView(game: self.$game, width: min(geo.size.width, geo.size.height))
						.frame(width: min(geo.size.width, geo.size.height))
						.frame(height: min(geo.size.width, geo.size.height))
						.preferredColorScheme(.dark)

					Spacer()
				}
			}
		}
	}
}

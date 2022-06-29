//
//  GameOver.swift
//  Werdle
//
//  Created by Rob Silverman on 6/29/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct GameOverView: View {
	
	@Binding var game: Game
	@Binding var show: Bool
	var width: CGFloat

	var body: some View {
		
		GeometryReader { geo in
			ZStack {
				if show {
					Color.black.opacity(show ? 0.3 : 0)
						.edgesIgnoringSafeArea(.all)
					VStack(alignment: .center, spacing: 5) {
						Spacer(minLength: 40)
						HStack(alignment: .center) {
							VStack(alignment: .center, spacing: 5) {
								
								Text(game.gameOverText)
								Button(action: {
									withAnimation(.linear(duration: 0.3)) {
										show = false
										game = Game()
									}
								}) {

									Text("New Game")
										.appFont(.black, size: 25)
										.padding()
								}.buttonStyle(ScaleButtonStyle())
							}
							.frame(maxWidth: 250, maxHeight: 150)
							.border(Colors.squareEmptyBorder, width: 2)
							.background(Colors.squareBackground)
							.shadow(color: Color(white: 0.2, opacity: 1), radius: 20, x: 0, y: 5)
						}
						Spacer()
						Spacer()
						Spacer()
					}
				}
			}
			
		}
	}
}

struct GameOverView_Previews: PreviewProvider {
	static var previews: some View {
		PreviewWrapper()
	}

	struct PreviewWrapper: View {

		@State(initialValue: Game()) var game: Game
		@State(initialValue: true) var show: Bool
		@State(initialValue: "Great job!") var message: String

		var body: some View {
			GeometryReader { geo in
				
				VStack {
					Spacer()
					GameOverView(game: self.$game, show: self.$show, width: min(geo.size.width, geo.size.height))
						.frame(width: min(geo.size.width, geo.size.height))
						.frame(height: min(geo.size.width, geo.size.height))
						.preferredColorScheme(.dark)
					Spacer()
				}
			}
		}
	}
}

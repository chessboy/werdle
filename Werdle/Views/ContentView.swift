//
//  ContentView.swift
//  Werdle
//
//  Created by Robert Silverman on 4/4/20.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	@State var game = Game()
	@State private var showingGameOver = false

	var body: some View {
		
		GeometryReader { geo in
			VStack(alignment: .center, spacing: 10) {
				
				Text("Werdle")
					.appFont(.black, size: 25)
					.padding()
			
				VStack {
					SquareView(width: min(geo.size.width, geo.size.height), game: $game)
					Spacer()
				}
				Spacer()
				KeyboardView(game: $game, width: min(geo.size.width, geo.size.height))
				
				Button(action: {
					if game.solved {
						game = Game()
					} else {
						withAnimation(.linear(duration: 0.3)) {
							showingGameOver.toggle()
						}
					}
				}) {

					Text(game.solved ? "New Game" : "Give Up")
						.appFont(.black, size: 20)
						.padding()
				}
				.overlay(RoundedRectangle(cornerRadius: 7).stroke(Color(.gray), lineWidth: 2))
				.buttonStyle(ScaleButtonStyle())
				Spacer(minLength: 50)
			}
			GameOverView(game: $game, show: $showingGameOver, width: min(geo.size.width, geo.size.height))
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		
//		ForEach(["iPhone 11 Pro Max", "iPhone 11 Pro", "iPhone 8 Plus", "iPhone 8"], id: \.self) { deviceName in

		ForEach(["iPhone 11 Pro Max", "iPhone 11 Pro"], id: \.self) { deviceName in
			ContentView()
				.previewDevice(PreviewDevice(rawValue: deviceName))
				.previewDisplayName(deviceName)
				.preferredColorScheme(.dark)
		}
    }
}

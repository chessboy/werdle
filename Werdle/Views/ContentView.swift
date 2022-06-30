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
	@State private var showingAlert = false

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
					withAnimation(.linear(duration: 0.3)) {
						showingAlert.toggle()
					}
				}) {

					Text("Give Up")
						.appFont(.black, size: 16)
						.padding([.top, .bottom], 10)
						.padding([.leading, .trailing], 20)
						.alert("Are you sure?", isPresented: $showingAlert) {
							Button("Cancel", role: .cancel) { }
							Button("Give Up", role: .destructive) {
								showingGameOver.toggle()
							}
						}
				}
				.overlay(RoundedRectangle(cornerRadius: 7).stroke(Color(.gray), lineWidth: 2))
				.buttonStyle(ScaleButtonStyle())
				.opacity(showingGameOver ? 0 : 1)
				Spacer(minLength: 50)
			}
			GameOverView(game: $game, show: $showingGameOver, width: min(geo.size.width, geo.size.height))
		}
		.onChange(of: game.solved) { solved in
			if solved {
				withAnimation(.linear(duration: 0.3)) {
					showingGameOver.toggle()
				}
			}
		}
		.onChange(of: game.lost) { lost in
			if lost {
				withAnimation(.linear(duration: 0.3)) {
					showingGameOver.toggle()
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		
//		ForEach(["iPhone 11 Pro Max", "iPhone 11 Pro", "iPhone 8 Plus", "iPhone 8"], id: \.self) { deviceName in

		ForEach(["iPhone 11 Pro Max", "iPhone 11 Pro", "iPhone 8"], id: \.self) { deviceName in
			ContentView()
				.previewDevice(PreviewDevice(rawValue: deviceName))
				.previewDisplayName(deviceName)
				.preferredColorScheme(.dark)
		}
    }
}

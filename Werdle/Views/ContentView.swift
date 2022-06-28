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

	var body: some View {
		
		GeometryReader { geo in
			VStack(alignment: .center, spacing: 10) {
				
				Button(action: {
					game = Game()
				}) {

					Text("Werdle")
						.appFont(.black, size: 25)
						.padding()
				}.buttonStyle(ScaleButtonStyle())
				
				VStack {
					SquareView(game: $game, width: min(geo.size.width, geo.size.height))
					Spacer()
				}
				Spacer()
				KeyboardView(game: $game, width: min(geo.size.width, geo.size.height))
				Spacer()
			}
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

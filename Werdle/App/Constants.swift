//
//  Positions.swift
//  Werdle
//
//  Created by Robert Silverman on 4/4/20.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import Foundation

struct Constants {
		
	static let wordLength = 5

	enum SystemIcon: String {
		case randomize = "shuffle"
		case flip = "arrow.2.squarepath"
	}
	
	struct Keyboard {
		static var row1: [String] = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
		static var row2: [String] = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
		static var row3: [String] = ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "DEL"]
	}
}

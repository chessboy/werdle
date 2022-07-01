//
//  LetterGuess.swift
//  Werdle
//
//  Created by Rob Silverman on 6/29/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import Foundation

struct LetterGuess: Identifiable, CustomStringConvertible, Comparable {
	var id: Int = 0
	var letter: String = ""
	var eval: LetterEval = .missing
	
	var description: String {
		return "\(id): \(letter == "" ? "_" : letter):\(eval)"
	}
	
	static func < (lhs: LetterGuess, rhs: LetterGuess) -> Bool {
		return lhs.eval < rhs.eval
	}
}

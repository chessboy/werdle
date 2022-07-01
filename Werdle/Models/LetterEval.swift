//
//  LetterEval.swift
//  Werdle
//
//  Created by Rob Silverman on 6/29/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

enum LetterEval: Int, Comparable, CustomStringConvertible {
	case blank = 0
	case missing
	case wrongPosition
	case correct
	
	var color: Color {
		switch self {
		case .blank: return Colors.squareBackground
		case .missing: return Colors.squareNotPresent
		case .wrongPosition: return Colors.squarePresentWrongPos
		case .correct: return Colors.squarePresentRightPos
		}
	}
	
	var borderColor: Color {
		switch self {
		case .blank: return Colors.squareEmptyBorder
		case .missing: return Colors.squareNotPresent
		case .wrongPosition: return Colors.squarePresentWrongPos
		case .correct: return Colors.squarePresentRightPos
		}
	}
	
	var description: String {
		switch self {
		case .blank: return "_"
		case .missing: return "x"
		case .wrongPosition: return "?"
		case .correct: return "√"
		}
	}
	
	static func < (lhs: LetterEval, rhs: LetterEval) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

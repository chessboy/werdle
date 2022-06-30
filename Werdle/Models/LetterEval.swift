//
//  LetterEval.swift
//  Werdle
//
//  Created by Rob Silverman on 6/29/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

enum LetterEval: CustomStringConvertible {
	case blank
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
	
	var priority: Int {
		switch self {
		case .blank: return 0
		case .missing: return 1
		case .wrongPosition: return 2
		case .correct: return 3
		}
	}
}

extension LetterEval: Comparable {
	static func < (lhs: LetterEval, rhs: LetterEval) -> Bool {
		return lhs.priority < rhs.priority
	}
}

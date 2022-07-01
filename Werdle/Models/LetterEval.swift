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
	case notInWord
	case notInPosition
	case inPosition
	
	var color: Color {
		switch self {
		case .blank: return Colors.squareBackground
		case .notInWord: return Colors.squareNotPresent
		case .notInPosition: return Colors.squarePresentWrongPos
		case .inPosition: return Colors.squarePresentRightPos
		}
	}
	
	var borderColor: Color {
		switch self {
		case .blank: return Colors.squareEmptyBorder
		case .notInWord: return Colors.squareNotPresent
		case .notInPosition: return Colors.squarePresentWrongPos
		case .inPosition: return Colors.squarePresentRightPos
		}
	}
	
	var description: String {
		switch self {
		case .blank: return "_"
		case .notInWord: return "x"
		case .notInPosition: return "?"
		case .inPosition: return "√"
		}
	}
    	
	static func < (lhs: LetterEval, rhs: LetterEval) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

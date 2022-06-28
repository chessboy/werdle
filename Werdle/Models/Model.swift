//
//  Guess.swift
//  Werdle
//
//  Created by Rob Silverman on 6/26/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import Foundation
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

struct LetterGuess: Identifiable, CustomStringConvertible {
	var id: Int = 0
	var letter: String = ""
	var eval: LetterEval = .missing
	
	var description: String {
		return "\(letter == "" ? "_" : letter):\(eval)"
	}
}

extension LetterGuess: Comparable {
	static func < (lhs: LetterGuess, rhs: LetterGuess) -> Bool {
		return lhs.eval.priority < rhs.eval.priority
	}
}

struct WordGuess: Identifiable {
	var id: Int = 0
	var letterGuesses: [LetterGuess] = []
	var correct: Bool = false
	
	static func emptyGuess(index: Int) -> WordGuess {
		var letterGuesses: [LetterGuess] = []
		
		for i in 0..<5 {
			letterGuesses.append(LetterGuess(id: i, letter: "", eval: .blank))
		}
		
		return WordGuess(id: index, letterGuesses: letterGuesses, correct: false)
	}
	
	static func evaluateWord(_ word: String, target: String, guessIndex: Int) -> WordGuess {
		
		guard word.count == 5 else {
			print("word.count != 5")
			return WordGuess.emptyGuess(index: guessIndex)
		}
		
		guard target.count == 5 else {
			print("target.count != 5")
			return WordGuess.emptyGuess(index: guessIndex)
		}

		let wordLetters = word.map { String($0) }
		let targetLetters = target.map { String($0) }

		var letterGuesses: [LetterGuess] = []	
		
		for i in 0..<5 {
			var eval: LetterEval = .wrongPosition
			let wordLetter = wordLetters[i]
			
			if !target.contains(wordLetter) {
				eval = .missing
			} else if wordLetter == targetLetters[i] {
				eval = .correct
			}
			
			letterGuesses.append(LetterGuess(id: i, letter: wordLetter, eval: eval))
		}
		
		let incorrect = letterGuesses.filter({ $0.eval != .correct }).count > 0

		return WordGuess(id: guessIndex, letterGuesses: letterGuesses, correct: !incorrect)
	}

}

struct Game {
	var target: String = "HELLO"
	var wordGuesses: [WordGuess] = []
	var uniqueLetterGuesses: [LetterGuess] = []
	var solved = false

	func colorForKeyboardLetter(_ letter: String) -> Color {
		if let letterGuess = uniqueLetterGuesses.filter({ $0.letter == letter }).first {
			return letterGuess.eval.color
		}
		return Colors.keyboardKey
	}
		
	var guessIndex: Int = 0
	
	init() {
		wordGuesses.append(WordGuess.emptyGuess(index: 0))
		wordGuesses.append(WordGuess.emptyGuess(index: 1))
		wordGuesses.append(WordGuess.emptyGuess(index: 2))
		wordGuesses.append(WordGuess.emptyGuess(index: 3))
		wordGuesses.append(WordGuess.emptyGuess(index: 4))
		wordGuesses.append(WordGuess.emptyGuess(index: 5))
	}
	
	mutating func addNewWordGuess(_ wordGuess: WordGuess) {
		
		wordGuesses[guessIndex] = wordGuess
		uniqueLetterGuesses = generateUniqueLetterGuesses()
		solved = wordGuess.correct

		let guessNumber = guessIndex + 1
		print("guess \(guessNumber): \(wordGuess), solved: \(solved)")
		print("guess \(guessNumber): uniqueLetterGuesses: \(uniqueLetterGuesses)")
		
		print()
		
		guessIndex += 1
	}
	
	static var testGame: Game {
		var game = Game()
		
		game.target = "RUSTY"
		game.addNewWordGuess(WordGuess.evaluateWord("CRANE", target: game.target, guessIndex: 0))
		game.addNewWordGuess(WordGuess.evaluateWord("STRIP", target: game.target, guessIndex: 1))
		game.addNewWordGuess(WordGuess.evaluateWord("ROUST", target: game.target, guessIndex: 2))
		game.addNewWordGuess(WordGuess.evaluateWord("RUSTY", target: game.target, guessIndex: 3))

		return game
	}
	
	func generateUniqueLetterGuesses() -> [LetterGuess] {
		var uniqueGuesses: [LetterGuess] = []
				
		var allLetterGuesses = wordGuesses.flatMap { wordGuess in
			return wordGuess.letterGuesses.filter {
				!$0.letter.isEmpty
			}
		}
		
		allLetterGuesses = allLetterGuesses.sorted{ (lhs, rhs) in
			if lhs.letter == rhs.letter { // <1>
				return lhs.eval > rhs.eval
			}
			return lhs.letter < rhs.letter // <2>
		}

		for letterGuess in allLetterGuesses {
			if !uniqueGuesses.map({ $0.letter }).contains(letterGuess.letter) {
				uniqueGuesses.append(letterGuess)
			}
		}
				
		return uniqueGuesses
	}
}

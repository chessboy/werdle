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
	var bad: Bool = false
	
	static func emptyGuess(index: Int) -> WordGuess {
		var letterGuesses: [LetterGuess] = []
		
		for i in 0..<5 {
			letterGuesses.append(LetterGuess(id: i, letter: "", eval: .blank))
		}
		
		return WordGuess(id: index, letterGuesses: letterGuesses, correct: false)
	}
	
	var word: String {
		return letterGuesses.map({ $0.letter }).joined()
	}
	
	var hasEmptyLetters: Bool {
		return letterGuesses.filter({ $0.letter.isEmpty }).count > 0
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

		print("evaluate word: \(word), target: \(target)")
		
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
	var guessIndex: Int = 0
	var letterIndex: Int = 0
	var currentGuess: WordGuess = WordGuess.emptyGuess(index: 0)
	var wordGuesses: [WordGuess] = []
	var uniqueLetterGuesses: [LetterGuess] = []
	var solved = false
	
	init() {
		target = Dataset.shared.randomWord
		print("target: \(target)")
		
		wordGuesses.append(WordGuess.emptyGuess(index: 0))
		wordGuesses.append(WordGuess.emptyGuess(index: 1))
		wordGuesses.append(WordGuess.emptyGuess(index: 2))
		wordGuesses.append(WordGuess.emptyGuess(index: 3))
		wordGuesses.append(WordGuess.emptyGuess(index: 4))
		wordGuesses.append(WordGuess.emptyGuess(index: 5))
	}
	
	mutating func acceptKey(_ key: String) {
		print("acceptKey: \(key)")
		
		if key == "ENTER" {
			handleEnterTyped()
		} else if key == "DEL" {
			handleDeleteTyped()
		} else {
			handleLetterTyped(key)
		}
	}
	
	private mutating func handleLetterTyped(_ letter: String) {
		guard currentGuess.hasEmptyLetters else { return }
		guard !solved else { return }
		
		currentGuess.letterGuesses[letterIndex] = LetterGuess(id: letterIndex, letter: letter, eval: .blank)
		wordGuesses[guessIndex] = currentGuess
		letterIndex += 1
		print("letterIndex: \(letterIndex), currentGuess: \(currentGuess)")
	}
	
	private mutating func handleDeleteTyped() {
		guard letterIndex >= 1 else { return }
		guard !solved else { return }

		currentGuess.bad = false
		currentGuess.letterGuesses[letterIndex - 1] = LetterGuess(id: letterIndex, letter: "", eval: .blank)
		wordGuesses[guessIndex] = currentGuess
		letterIndex -= 1
		print("letterIndex: \(letterIndex), currentGuess: \(currentGuess)")
	}
	
	private mutating func handleEnterTyped() {
		guard !currentGuess.hasEmptyLetters else { return }
		guard !solved else { return }

		let word = currentGuess.word
		if Dataset.shared.containsWord(word) {
			print("handleEnterTyped: good word: \(word)")
			let wordGuess = WordGuess.evaluateWord(word, target: target, guessIndex: guessIndex)
			addNewWordGuess(wordGuess)
		} else {
			print("handleEnterTyped: bad word: \(word)")
			currentGuess.bad = true
			wordGuesses[guessIndex] = currentGuess

			print("letterIndex: \(letterIndex), currentGuess: \(currentGuess)")
		}
	}
	
	func colorForKeyboardLetter(_ letter: String) -> Color {
		if let letterGuess = uniqueLetterGuesses.filter({ $0.letter == letter }).first {
			return letterGuess.eval.color
		}
		return Colors.keyboardKey
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
		letterIndex = 0
		currentGuess = WordGuess.emptyGuess(index: guessIndex)
	}
	
	static var testGame: Game {
		var game = Game()
		game.target = "ACORN"
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

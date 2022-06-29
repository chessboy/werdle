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
		return "\(id): \(letter == "" ? "_" : letter):\(eval)"
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

		//print("evaluate word: \(word), target: \(target)")
		
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
		
		letterGuesses = adjustForRepeatedLetters(letterGuesses: letterGuesses)
		let incorrect = letterGuesses.filter({ $0.eval != .correct }).count > 0

		return WordGuess(id: guessIndex, letterGuesses: letterGuesses, correct: !incorrect)
	}

	static func adjustForRepeatedLetters(letterGuesses: [LetterGuess]) -> [LetterGuess] {
		var adjustedLetterGuesses: [LetterGuess] = []
		
		// now check for multiple occurrences of the same letter
		for var letterGuess in letterGuesses {
			if letterGuess.eval == .wrongPosition {
				if letterGuesses.filter({ $0.id != letterGuess.id && $0.letter == letterGuess.letter && letterGuess.eval != .missing && $0.id < letterGuess.id }).first != nil {
					// we have a letter who matches in one position, but not this one
					letterGuess.eval = .missing
				}
			}
			
			adjustedLetterGuesses.append(letterGuess)
		}
	
		return adjustedLetterGuesses
	}
}

struct Game {
	var target: String = "STARS"
	var guessIndex: Int = 0
	var letterIndex: Int = 0
	var currentGuess: WordGuess = WordGuess.emptyGuess(index: 0)
	var wordGuesses: [WordGuess] = []
	var uniqueLetterGuesses: [LetterGuess] = []
	var solved = false
	var lost = false

	init() {
		target = Dataset.shared.randomWord
		//print("target: \(target)")
		
		for i in 0..<5 {
			wordGuesses.append(WordGuess.emptyGuess(index: i))
		}
	}
	
	mutating func acceptKey(_ key: String) {
		//print("acceptKey: \(key)")
		
		if key == "ENTER" {
			handleEnterTyped()
		} else if key == "DEL" {
			handleDeleteTyped()
		} else {
			handleLetterTyped(key)
		}
	}
	
	private mutating func handleLetterTyped(_ letter: String) {
		guard guessIndex < 5 else { return }
		guard currentGuess.hasEmptyLetters else { return }
		guard !solved, !lost else { return }
		
		currentGuess.letterGuesses[letterIndex] = LetterGuess(id: letterIndex, letter: letter, eval: .blank)
		wordGuesses[guessIndex] = currentGuess
		letterIndex += 1
		//print("letterIndex: \(letterIndex), currentGuess: \(currentGuess)")
	}
	
	private mutating func handleDeleteTyped() {
		guard letterIndex >= 1 else { return }
		guard !solved, !lost else { return }

		currentGuess.bad = false
		currentGuess.letterGuesses[letterIndex - 1] = LetterGuess(id: letterIndex - 1, letter: "", eval: .blank)
		wordGuesses[guessIndex] = currentGuess
		letterIndex -= 1
		//print("letterIndex: \(letterIndex), currentGuess: \(currentGuess)")
	}
	
	private mutating func handleEnterTyped() {
		guard !currentGuess.hasEmptyLetters else { return }
		guard !solved, !lost else { return }

		let word = currentGuess.word
		if Dataset.shared.containsWord(word) {
			//print("handleEnterTyped: good word: \(word)")
			let wordGuess = WordGuess.evaluateWord(word, target: target, guessIndex: guessIndex)
			addNewWordGuess(wordGuess)
		} else {
			//print("handleEnterTyped: bad word: \(word)")
			currentGuess.bad = true
			wordGuesses[guessIndex] = currentGuess
			//print("letterIndex: \(letterIndex), currentGuess: \(currentGuess)")
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

//		let guessNumber = guessIndex + 1
//		print("guess \(guessNumber): \(wordGuess), solved: \(solved)")
//		print("guess \(guessNumber): uniqueLetterGuesses: \(uniqueLetterGuesses)")
//		print()
		
		guessIndex += 1
		letterIndex = 0
		currentGuess = WordGuess.emptyGuess(index: guessIndex)

		if guessIndex == 5, !solved {
			lost = true
		}
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

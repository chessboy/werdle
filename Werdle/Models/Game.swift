//
//  Game.swift
//  Werdle
//
//  Created by Rob Silverman on 6/29/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct Game {
	var target: String = "HELLO"
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
	
	var gameOverText: String {
		if solved {
			return "Yes, it's \(target). Great job!"
		} else {
			return "The answer was \(target)"
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

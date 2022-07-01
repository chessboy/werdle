//
//  WordGuess.swift
//  Werdle
//
//  Created by Rob Silverman on 6/29/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import Foundation

struct WordGuess: Identifiable {
	var id: Int = 0
	var letterGuesses: [LetterGuess] = []
	var correct: Bool = false
	var bad: Bool = false
	
	// placeholder for laying out ui
	static func emptyGuess(index: Int) -> WordGuess {
		var letterGuesses: [LetterGuess] = []
		
        for i in 0..<Constants.wordLength {
			letterGuesses.append(LetterGuess(id: i, letter: "", eval: .blank))
		}
		
		return WordGuess(id: index, letterGuesses: letterGuesses, correct: false)
	}
	
	// the guesses joined as a single string
	var word: String {
		return letterGuesses.map({ $0.letter }).joined()
	}
	
	// true if any letter guesses are empty
	var hasEmptyLetters: Bool {
		return letterGuesses.filter({ $0.letter.isEmpty }).count > 0
	}
	
	// return an evaluated WordGuess
	static func evaluateWord(_ word: String, target: String, guessIndex: Int) -> WordGuess {
		guard word.count == Constants.wordLength else {
			print("word.count != \(Constants.wordLength)")
			return WordGuess.emptyGuess(index: guessIndex)
		}
		
		guard target.count == Constants.wordLength else {
			print("target.count != \(Constants.wordLength)")
			return WordGuess.emptyGuess(index: guessIndex)
		}
		
		let wordLetters = word.map { String($0) }
		let targetLetters = target.map { String($0) }
		var letterGuesses: [LetterGuess] = []
		
		for i in 0..<Constants.wordLength {
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
		var wordGuess = WordGuess(id: guessIndex, letterGuesses: letterGuesses, correct: !incorrect)
		wordGuess.cleanupWrongPositionEvals(target: target)
		
		return wordGuess
	}

	// check for multiple wrong positions of the same letter and prune accordingly to match target count
	private mutating func cleanupWrongPositionEvals(target: String) {
		for var letterGuess in letterGuesses.reversed() {
			if letterGuess.eval == .wrongPosition {
				
				let targetCount = target.numberOfOccurrencesOf(string: letterGuess.letter)
				let correctCount = letterGuesses.filter{ $0.eval == .correct && $0.letter == letterGuess.letter }.count
				let wrongPositionCount = letterGuesses.filter{ $0.eval == .wrongPosition && $0.letter == letterGuess.letter }.count

				//print("target \(letterGuess.letter) count: \(targetCount)")
				//print("guesses correct \(letterGuess.letter) count: \(correctCount)")
				//print("guesses wrong \(letterGuess.letter) count: \(wrongPositionCount)")

				if targetCount - correctCount < wrongPositionCount {
					//print("marking: \(letterGuess) as missing")
					letterGuess.eval = .missing
					letterGuesses[letterGuess.id] = letterGuess
				}
			}
		}
	}
}
